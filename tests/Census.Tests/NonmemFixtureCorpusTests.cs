using System.Globalization;
using System.Text;
using Census.Domain;
using Census.Import;
using VerifyXunit;
using Xunit;

namespace Census.Tests;

/// <summary>
/// Regression coverage for the NONMEM XML importer against a committed, representative
/// fixture corpus (see <c>fixtures/nonmem/README.md</c>). Unlike the optional local sweep in
/// <see cref="RealWorldImporterTests"/>, these tests always run in CI and FAIL when the corpus
/// is missing, so the importer cannot silently regress against real NONMEM output.
///
/// The committed corpus is a deliberate subset: runs R001 (cov step, small), R027 (cov step,
/// larger) and R041 (no cov step) across three distinct output formats — NONMEM 7.3, 7.4.3 and
/// 7.5.0. (The "7.6" IQ package emits byte-identical 7.5.0 output, so it is not duplicated.)
/// </summary>
public sealed class NonmemFixtureCorpusTests : VerifyBase
{
    public NonmemFixtureCorpusTests() : base()
    {
    }

    private static readonly string[] Versions = ["nm73", "nm743", "nm750"];
    private static readonly string[] Runs = ["runR001", "runR027", "runR041"];

    private static string CorpusDir =>
        Path.Combine(AppContext.BaseDirectory, "fixtures", "nonmem");

    public static IEnumerable<object[]> Fixtures =>
        from v in Versions
        from r in Runs
        select new object[] { v, r };

    [Fact]
    public void Corpus_IsPresent()
    {
        Assert.True(Directory.Exists(CorpusDir),
            $"Committed NONMEM fixture corpus is missing at '{CorpusDir}'. " +
            "This corpus is required regression coverage — see fixtures/nonmem/README.md.");

        var missing = (from v in Versions
                       from r in Runs
                       let path = Path.Combine(CorpusDir, v, r + ".xml")
                       where !File.Exists(path)
                       select $"{v}/{r}.xml").ToList();

        Assert.True(missing.Count == 0,
            "Missing committed NONMEM fixtures: " + string.Join(", ", missing));
    }

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void Fixture_Parses_WithSaneStructure(string version, string run)
    {
        var run0 = ImportFixture(version, run);

        Assert.False(string.IsNullOrEmpty(run0.RunNo));
        Assert.NotEmpty(run0.Estimations);

        foreach (var est in run0.Estimations)
        {
            Assert.False(string.IsNullOrEmpty(est.Method));
            Assert.NotEmpty(est.Parameters);
            // A standard error without an estimate is never valid NONMEM output.
            Assert.True(est.Parameters.All(p => p.Estimate.HasValue || p.StandardError is null),
                $"{version}/{run}: parameter without an estimate carries a standard error");
        }
    }

    /// <summary>
    /// Golden snapshot: the human-readable oracle table of expected values for the whole corpus.
    /// The committed <c>.verified.txt</c> is the written record of what the importer produces.
    /// To update it intentionally, run the tests and accept the new <c>.received.txt</c>.
    /// </summary>
    [Fact]
    public Task Corpus_Snapshot_MatchesOracle()
    {
        var sb = new StringBuilder();
        foreach (var version in Versions)
        {
            foreach (var run in Runs)
            {
                AppendRun(sb, version, run, ImportFixture(version, run));
            }
        }

        return Verify(sb.ToString());
    }

    private static Run ImportFixture(string version, string run)
    {
        var path = Path.Combine(CorpusDir, version, run + ".xml");
        // ImportXml (not Import) keeps the result deterministic: no absolute sibling-file paths
        // and no machine-specific MD5, so the snapshot is stable across machines and CI.
        return new NonmemXmlImporter().ImportXml(File.ReadAllText(path), path);
    }

    private static void AppendRun(StringBuilder sb, string version, string run, Run r)
    {
        sb.Append("== ").Append(version).Append('/').Append(run).AppendLine(" ==");
        sb.Append("RunNo=").Append(r.RunNo)
          .Append("  ObsRecs=").Append(Fmt(r.ObsRecs))
          .Append("  Individuals=").Append(Fmt(r.Individuals))
          .AppendLine();

        foreach (var est in r.Estimations)
        {
            sb.Append("  Est#").Append(est.Number).Append(' ').Append(est.Method)
              .Append("  OFV=").Append(Fmt(est.Ofv))
              .Append("  Cond=").Append(Fmt(est.ConditionNumber))
              .Append("  Warnings=").Append(est.Warnings.Count)
              .AppendLine();

            AppendParams(sb, "THETA", est, ParameterKind.Theta);
            AppendParams(sb, "OMEGA", est, ParameterKind.Omega);
            AppendParams(sb, "SIGMA", est, ParameterKind.Sigma);
        }

        sb.AppendLine();
    }

    private static void AppendParams(StringBuilder sb, string label, Estimation est, ParameterKind kind)
    {
        var ps = est.Parameters.Where(p => p.Kind == kind).OrderBy(p => p.Index).ToList();
        if (ps.Count == 0)
        {
            return;
        }

        sb.Append("    ").Append(label).Append(": ")
          .AppendLine(string.Join(", ", ps.Select(p =>
              $"[{p.Index}] est={Fmt(p.Estimate)} se={Fmt(p.StandardError)} shrink={Fmt(p.Shrinkage)}")));
    }

    // Six significant figures in the invariant culture: enough to catch a real parser regression,
    // stable across machines (the parse itself is exact and deterministic).
    private static string Fmt(double? d) =>
        d.HasValue ? d.Value.ToString("G6", CultureInfo.InvariantCulture) : "·";

    private static string Fmt(int? i) =>
        i.HasValue ? i.Value.ToString(CultureInfo.InvariantCulture) : "·";
}
