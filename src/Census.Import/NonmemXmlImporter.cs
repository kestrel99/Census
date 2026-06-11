using System.Globalization;
using System.Security.Cryptography;
using System.Xml.Linq;
using Census.Domain;

namespace Census.Import;

/// <summary>
/// Imports NONMEM 7.2+ XML output files into <see cref="Run"/> domain objects.
/// Parses by local element/attribute name so it is robust to the nm: namespace prefix
/// used in real NONMEM 7.3+ output and to bare-name older output.
/// </summary>
public sealed class NonmemXmlImporter : IRunImporter
{
    public bool CanImport(string sourcePath) =>
        sourcePath.EndsWith(".xml", StringComparison.OrdinalIgnoreCase);

    public Run Import(string sourcePath)
    {
        var xml = File.ReadAllText(sourcePath);
        var run = ImportXml(xml, sourcePath);
        var md5 = ComputeMd5(sourcePath);
        return run with
        {
            Files = [new FileArtifact { Role = "output", Path = sourcePath, Md5 = md5 }],
        };
    }

    /// <summary>Parse from an XML string. Exposed for testing without disk I/O.</summary>
    public Run ImportXml(string xml, string sourcePath)
    {
        var doc = XDocument.Parse(xml);
        var root = doc.Root!;

        var nonmem = El(root, "nonmem");
        var firstProblem = nonmem is not null ? El(nonmem, "problem") : null;

        var obsRecs = ParseInt(Attr(El(firstProblem, "problem_options"), "data_nobs"));
        var individuals = ParseInt(Attr(El(firstProblem, "problem_options"), "data_nind"));

        var estimations = firstProblem is not null
            ? ParseEstimations(firstProblem)
            : [];

        var runNo = DeriveRunNo(sourcePath);

        // Comment defaults to the $PROBLEM title. A PsN run name, when we import one,
        // takes precedence; until then the problem title is the best human label.
        var problemTitle = El(firstProblem, "problem_title")?.Value?.Trim();

        // Run-level timing: start/stop timestamps and total CPU time live on <output>.
        var startDateTime = El(root, "start_datetime")?.Value?.Trim();
        var stopDateTime = El(root, "stop_datetime")?.Value?.Trim();
        var totalCpuTime = ParseDouble(El(root, "total_cputime")?.Value);

        // Post-processing times live under <problem>/<post_process_times>.
        var postTimes = El(firstProblem, "post_process_times");
        var postElapsed = ParseDouble(El(postTimes, "post_elapsed_time")?.Value);
        var finalOutputElapsed = ParseDouble(El(postTimes, "finaloutput_elapsed_time")?.Value);

        return new Run
        {
            RunNo = runNo,
            IRunNo = int.TryParse(runNo, NumberStyles.Integer, CultureInfo.InvariantCulture, out var n) ? n : 0,
            Comment = string.IsNullOrEmpty(problemTitle) ? null : problemTitle,
            ObsRecs = obsRecs,
            Individuals = individuals,
            StartDateTime = string.IsNullOrEmpty(startDateTime) ? null : startDateTime,
            StopDateTime = string.IsNullOrEmpty(stopDateTime) ? null : stopDateTime,
            TotalCpuTime = totalCpuTime,
            PostElapsedTime = postElapsed,
            FinalOutputElapsedTime = finalOutputElapsed,
            Estimations = estimations,
            Files = [],
        };
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private static List<Estimation> ParseEstimations(XElement problem)
    {
        var result = new List<Estimation>();

        // Both "estimation" and "sir_estimation" (NONMEM 7.6+) follow the same sub-structure.
        foreach (var estEl in problem.Elements()
            .Where(e => e.Name.LocalName is "estimation" or "sir_estimation"))
        {
            var number = ParseInt(Attr(estEl, "number")) ?? 0;
            var method = El(estEl, "estimation_method")?.Value?.Trim();
            var ofv = ParseDouble(El(estEl, "final_objective_function")?.Value);
            // Condition number = ratio of largest to smallest eigenvalue of the correlation
            // matrix. Prefer an explicit <eigenvalues> vector or populated covariance_status;
            // otherwise compute it from the <correlation> matrix (NM 7.3 leaves the others empty).
            var conditionNumber =
                ConditionNumberFromEigenvalues(El(estEl, "eigenvalues"))
                ?? ConditionNumberFromCovarianceStatus(El(estEl, "covariance_status"))
                ?? ConditionNumberFromCorrelation(El(estEl, "correlation"));
            var estimationTime = ParseDouble(El(estEl, "estimation_elapsed_time")?.Value);
            var covarianceTime = ParseDouble(El(estEl, "covariance_elapsed_time")?.Value);

            // Shrinkage: prefer etashrinksd (7.3+, SD-based) over etashrink (7.2 legacy).
            var etaShrinkEl = El(estEl, "etashrinksd") ?? El(estEl, "etashrink");
            var epsShrinkEl = El(estEl, "epsshrinksd") ?? El(estEl, "epsshrink");

            var thetas = ParseThetas(El(estEl, "theta"), El(estEl, "thetase"));
            var omegas = ParseMatrix(ParameterKind.Omega, El(estEl, "omega"), El(estEl, "omegase"), etaShrinkEl);
            var sigmas = ParseMatrix(ParameterKind.Sigma, El(estEl, "sigma"), El(estEl, "sigmase"), epsShrinkEl);

            var warnings = ParseWarnings(
                El(estEl, "termination_status"),
                El(estEl, "termination_information"));

            result.Add(new Estimation
            {
                Number = number,
                Method = method,
                Ofv = ofv,
                ConditionNumber = conditionNumber,
                EstimationTime = estimationTime,
                CovarianceTime = covarianceTime,
                Covariance = ParseNamedMatrix(El(estEl, "covariance")),
                Correlation = ParseNamedMatrix(El(estEl, "correlation")),
                Parameters = [.. thetas, .. omegas, .. sigmas],
                Warnings = warnings,
            });
        }

        return result;
    }

    private static List<Parameter> ParseThetas(XElement? thetaEl, XElement? thetaseEl)
    {
        if (thetaEl is null)
        {
            return [];
        }

        var estimates = Els(thetaEl, "val").ToList();
        var ses = thetaseEl is not null ? Els(thetaseEl, "val").ToList() : [];

        var result = new List<Parameter>(estimates.Count);
        for (var i = 0; i < estimates.Count; i++)
        {
            result.Add(new Parameter
            {
                Kind = ParameterKind.Theta,
                Index = i + 1,
                Label = Attr(estimates[i], "name")?.Trim(),
                Estimate = ParseDouble(estimates[i].Value),
                StandardError = i < ses.Count ? ParseDouble(ses[i].Value) : null,
            });
        }

        return result;
    }

    private static List<Parameter> ParseMatrix(
        ParameterKind kind,
        XElement? matEl,
        XElement? seEl,
        XElement? shrinkEl)
    {
        if (matEl is null)
        {
            return [];
        }

        // Lower-triangular matrix: row i has i cols; diagonal = last col of each row.
        var rows = Els(matEl, "row").ToList();
        var seRows = seEl is not null ? Els(seEl, "row").ToList() : [];
        var shrinkValues = FlattenShrinkageValues(shrinkEl);

        var result = new List<Parameter>(rows.Count);
        for (var i = 0; i < rows.Count; i++)
        {
            var diagonalCol = Els(rows[i], "col").LastOrDefault();
            var diagonalSe = i < seRows.Count
                ? Els(seRows[i], "col").LastOrDefault()
                : null;

            result.Add(new Parameter
            {
                Kind = kind,
                Index = i + 1,
                Label = Attr(rows[i], "rname")?.Trim(),
                Estimate = diagonalCol is not null ? ParseDouble(diagonalCol.Value) : null,
                StandardError = diagonalSe is not null ? ParseDouble(diagonalSe.Value) : null,
                Shrinkage = i < shrinkValues.Count ? shrinkValues[i] : null,
            });
        }

        return result;
    }

    // Parse a labelled lower-triangular matrix (covariance/correlation) from its XML element.
    private static NamedMatrix? ParseNamedMatrix(XElement? matEl)
    {
        if (matEl is null)
        {
            return null;
        }

        var rows = Els(matEl, "row").ToList();
        if (rows.Count == 0)
        {
            return null;
        }

        var labels = rows.Select(r => Attr(r, "rname")?.Trim() ?? string.Empty).ToList();
        var values = rows
            .Select(r => (IReadOnlyList<double?>)Els(r, "col").Select(c => ParseDouble(c.Value)).ToList())
            .ToList();

        return new NamedMatrix { Labels = labels, Values = values };
    }

    // Shrinkage tables come in two layouts:
    //   Flat (7.3–7.5): one row per subpopulation, one col per eta/eps.
    //   Per-parameter (fixture / 7.6+): one row per eta/eps, one col per row.
    // Both produce the same indexed list of values.
    private static List<double?> FlattenShrinkageValues(XElement? shrinkEl)
    {
        if (shrinkEl is null) return [];
        var rows = Els(shrinkEl, "row").ToList();
        if (rows.Count == 0) return [];

        var firstRowCols = Els(rows[0], "col").ToList();
        if (rows.Count == 1 && firstRowCols.Count > 1)
            return firstRowCols.Select(c => ParseDouble(c.Value)).ToList();

        return rows.Select(r => ParseDouble(Els(r, "col").FirstOrDefault()?.Value)).ToList();
    }

    // Condition number from an explicit <eigenvalues> vector (eigenvalues of the correlation matrix).
    private static double? ConditionNumberFromEigenvalues(XElement? eigEl)
    {
        if (eigEl is null)
        {
            return null;
        }

        var vals = Els(eigEl, "val")
            .Select(v => ParseDouble(v.Value))
            .Where(d => d.HasValue)
            .Select(d => d!.Value)
            .ToList();

        if (vals.Count == 0)
        {
            return null;
        }

        var min = vals.Min();
        var max = vals.Max();
        return min > 0 ? max / min : null;
    }

    // Condition number from covariance_status eigenvalue attributes, when populated and positive.
    // Some NONMEM versions leave these zero (or negative for non-positive-definite matrices).
    private static double? ConditionNumberFromCovarianceStatus(XElement? covStatusEl)
    {
        if (covStatusEl is null)
        {
            return null;
        }

        var minVal = ParseDouble(Attr(covStatusEl, "mineigenvalue"));
        var maxVal = ParseDouble(Attr(covStatusEl, "maxeigenvalue"));

        if (minVal is null || maxVal is null || minVal.Value <= 0.0 || maxVal.Value <= 0.0)
        {
            return null;
        }

        return maxVal.Value / minVal.Value;
    }

    // Condition number computed from the <correlation> matrix. NONMEM stores standard errors on
    // the diagonal and correlation coefficients off-diagonal; the condition number is the ratio of
    // the largest to smallest eigenvalue of the correlation matrix (unit diagonal). Parameters with
    // no standard error (fixed) are excluded, matching NONMEM.
    private static double? ConditionNumberFromCorrelation(XElement? corrEl)
    {
        if (corrEl is null)
        {
            return null;
        }

        var rows = Els(corrEl, "row").ToList();
        var n = rows.Count;
        if (n == 0)
        {
            return null;
        }

        var cells = rows.Select(r => Els(r, "col").Select(c => ParseDouble(c.Value)).ToList()).ToList();

        // Active parameters have a non-zero standard error on the diagonal.
        var active = Enumerable.Range(0, n)
            .Where(i => i < cells[i].Count && (cells[i][i] ?? 0.0) != 0.0)
            .ToArray();

        var m = active.Length;
        if (m == 0)
        {
            return null;
        }

        var r = new double[m, m];
        for (var a = 0; a < m; a++)
        {
            r[a, a] = 1.0;
            var i = active[a];
            for (var b = 0; b < a; b++)
            {
                var j = active[b];
                var v = j < cells[i].Count ? cells[i][j] ?? 0.0 : 0.0;
                r[a, b] = v;
                r[b, a] = v;
            }
        }

        var eig = SymmetricEigenvalues(r, m);
        var min = eig.Min();
        var max = eig.Max();
        return min > 0 ? max / min : null;
    }

    // Eigenvalues of a symmetric matrix via the cyclic Jacobi rotation method.
    private static double[] SymmetricEigenvalues(double[,] a, int n)
    {
        for (var sweep = 0; sweep < 100; sweep++)
        {
            var off = 0.0;
            for (var p = 0; p < n; p++)
            {
                for (var q = p + 1; q < n; q++)
                {
                    off += a[p, q] * a[p, q];
                }
            }

            if (off < 1e-20)
            {
                break;
            }

            for (var p = 0; p < n; p++)
            {
                for (var q = p + 1; q < n; q++)
                {
                    if (Math.Abs(a[p, q]) < 1e-300)
                    {
                        continue;
                    }

                    var theta = (a[q, q] - a[p, p]) / (2.0 * a[p, q]);
                    var t = theta == 0.0
                        ? 1.0
                        : Math.Sign(theta) / (Math.Abs(theta) + Math.Sqrt(theta * theta + 1.0));
                    var c = 1.0 / Math.Sqrt(t * t + 1.0);
                    var s = t * c;

                    for (var k = 0; k < n; k++)
                    {
                        var akp = a[k, p];
                        var akq = a[k, q];
                        a[k, p] = c * akp - s * akq;
                        a[k, q] = s * akp + c * akq;
                    }

                    for (var k = 0; k < n; k++)
                    {
                        var apk = a[p, k];
                        var aqk = a[q, k];
                        a[p, k] = c * apk - s * aqk;
                        a[q, k] = s * apk + c * aqk;
                    }
                }
            }
        }

        var eigenvalues = new double[n];
        for (var i = 0; i < n; i++)
        {
            eigenvalues[i] = a[i, i];
        }

        return eigenvalues;
    }

    private static List<string> ParseWarnings(XElement? statusEl, XElement? infoEl)
    {
        if (statusEl is null)
        {
            return [];
        }

        if (!int.TryParse(statusEl.Value.Trim(), NumberStyles.Integer, CultureInfo.InvariantCulture, out var status) ||
            status == 0)
        {
            return [];
        }

        var text = infoEl?.Value?.Trim();
        return string.IsNullOrEmpty(text) ? [] : [text];
    }

    private static string DeriveRunNo(string sourcePath)
    {
        var stem = Path.GetFileNameWithoutExtension(sourcePath);

        // Extract trailing digits. Works for "run27", "sim1", "1", etc.
        var i = stem.Length - 1;
        while (i >= 0 && char.IsDigit(stem[i]))
        {
            i--;
        }

        // If we found digits, return them; otherwise return the whole stem.
        return i < stem.Length - 1 ? stem[(i + 1)..] : stem;
    }

    private static string ComputeMd5(string filePath)
    {
        var bytes = File.ReadAllBytes(filePath);
        var hash = MD5.HashData(bytes);
        return Convert.ToHexString(hash).ToLowerInvariant();
    }

    // Select by local name — transparent to nm: prefix used in real NONMEM output.
    private static XElement? El(XContainer? parent, string localName) =>
        parent?.Elements().FirstOrDefault(e => e.Name.LocalName == localName);

    private static IEnumerable<XElement> Els(XContainer parent, string localName) =>
        parent.Elements().Where(e => e.Name.LocalName == localName);

    // Attribute lookup by local name (real NONMEM uses nm:name="..." on attributes too).
    private static string? Attr(XElement? el, string localName) =>
        el?.Attributes().FirstOrDefault(a => a.Name.LocalName == localName)?.Value;

    private static double? ParseDouble(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        return double.TryParse(value.Trim(), NumberStyles.Float, CultureInfo.InvariantCulture, out var d)
            ? d
            : null;
    }

    private static int? ParseInt(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        return int.TryParse(value.Trim(), NumberStyles.Integer, CultureInfo.InvariantCulture, out var i)
            ? i
            : null;
    }
}
