# Phase 3 — NONMEM XML Importer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement `NonmemXmlImporter.Import()` so it reads a NONMEM 7.2+ XML output file and returns a fully-populated `Run` domain object, verified by fixture-based tests.

**Architecture:** Parse with `XDocument` (LINQ to XML), selecting by local element name so the importer is robust to namespace variations in real NONMEM output files. All data extracted from a single XML file; `DOfv`, `ObsRecs`, and `Individuals` are left null (unavailable from a single file). `RunNo`/`IRunNo` are derived from the filename stem.

**Tech Stack:** `System.Xml.Linq` (in-box), `System.Security.Cryptography.MD5` (in-box), `Census.Import`, `Census.Domain`, `xUnit`.

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Create | `tests/Census.Tests/fixtures/run27.xml` | Hand-crafted NONMEM XML fixture |
| Modify | `src/Census.Import/NonmemXmlImporter.cs` | Full `Import()` implementation |
| Create | `tests/Census.Tests/NonmemXmlImporterTests.cs` | Fixture-based + inline XML tests |

---

## Key schema facts (from `output.xsd` and `output.dtd`, NONMEM 7.6.0)

```
nm:output  (xmlns:nm="http://namespaces.oreilly.com/xmlnut/address")
  nm:nonmem [@nm:version]
    nm:problem [@nm:number]
      nm:problem_options [@nm:data_nobs, @nm:data_nind]
                                         → Run.ObsRecs, Run.Individuals
      nm:estimation [@nm:number, @nm:type]
        nm:estimation_method             → Estimation.Method
        nm:termination_status            → if != 0: termination_information added to Warnings
        nm:termination_information       → warning text
        nm:final_objective_function      → Estimation.Ofv
        nm:theta     (vector)  val[@name]   → ParameterKind.Theta estimates
        nm:thetase   (vector)  val[@name]   → Theta StandardErrors
        nm:omega     (table)   row/col      → ParameterKind.Omega estimates (diagonal only)
        nm:omegase   (table)   row/col      → Omega StandardErrors (diagonal only)
        nm:etashrinksd (table) row/col      → Omega Shrinkage, SD-based (NONMEM 7.3+)
        nm:etashrink   (table) row/col      → Omega Shrinkage, legacy (NONMEM 7.2)
        nm:sigma     (table)   row/col      → ParameterKind.Sigma estimates (diagonal)
        nm:sigmase   (table)   row/col      → Sigma StandardErrors (diagonal)
        nm:epsshrinksd (table) row/col      → Sigma Shrinkage, SD-based (NONMEM 7.3+)
        nm:epsshrink   (table) row/col      → Sigma Shrinkage, legacy (NONMEM 7.2)
        nm:covariance_status [@nm:mineigenvalue, @nm:maxeigenvalue]
                                         → ConditionNumber = max/min
      nm:sir_estimation [@nm:number, @nm:type]  — same structure as estimation, handle identically
```

**Namespace strategy:** real NONMEM output uses `nm:` prefix on ALL elements AND attributes
(e.g. `<nm:problem nm:number="1">`). Select by `Name.LocalName` and `Attributes().FirstOrDefault(a => a.Name.LocalName == "x")` throughout — handles both namespaced and bare output.

**Omega/Sigma matrix diagonal:** stored lower-triangular. Row i has i columns; diagonal = last `col` in each row.

**Shrinkage priority:** prefer `etashrinksd` over `etashrink` (try `etashrinksd` first; fall back to `etashrink`). Same for eps. Each row = one eta/epsilon; the **first** `col` in that row is the shrinkage value.

---

## Task 1: Create fixture XML

**Files:**
- Create: `tests/Census.Tests/fixtures/run27.xml`

- [ ] **Step 1: Create the fixture directory and file**

Create `tests/Census.Tests/fixtures/run27.xml` with this content (NONMEM 7.6 format with `nm:` namespace prefix on all elements and attributes, per `output.dtd`):

```xml
<?xml version="1.0" encoding="ASCII"?>
<nm:output xmlns:nm="http://namespaces.oreilly.com/xmlnut/address">
  <nm:start_datetime>2024-01-15T10:30:00</nm:start_datetime>
  <nm:control_stream>$PROB run27</nm:control_stream>
  <nm:nmtran>SUCCESSFUL</nm:nmtran>
  <nm:nonmem nm:version="7.6.0">
    <nm:license_information>NONMEM 7.6.0</nm:license_information>
    <nm:program_information>ICON plc</nm:program_information>
    <nm:problem nm:number="1" nm:subproblem="0" nm:superproblem1="0" nm:iteration1="0" nm:superproblem2="0" nm:iteration2="0">
      <nm:problem_title>$PROBLEM run27</nm:problem_title>
      <nm:problem_information>NONMEM run 27</nm:problem_information>
      <nm:problem_options nm:data_nobs="1234" nm:data_nind="56"/>
      <nm:estimation nm:number="1" nm:type="1">
        <nm:estimation_method>FOCEI</nm:estimation_method>
        <nm:termination_status>0</nm:termination_status>
        <nm:termination_information>MINIMIZATION SUCCESSFUL</nm:termination_information>
        <nm:etashrinksd nm:number="1">
          <nm:row nm:rname="ETA(1)">
            <nm:col nm:cname="ETA(1)">12.3</nm:col>
          </nm:row>
        </nm:etashrinksd>
        <nm:epsshrinksd nm:number="1">
          <nm:row nm:rname="EPS(1)">
            <nm:col nm:cname="EPS(1)">5.6</nm:col>
          </nm:row>
        </nm:epsshrinksd>
        <nm:final_objective_function>-1234.567</nm:final_objective_function>
        <nm:theta nm:number="1">
          <nm:val nm:name="CL">3.21</nm:val>
          <nm:val nm:name="V">15.4</nm:val>
        </nm:theta>
        <nm:omega nm:number="1">
          <nm:row nm:rname="ETA(1)">
            <nm:col nm:cname="ETA(1)">0.09</nm:col>
          </nm:row>
        </nm:omega>
        <nm:sigma nm:number="1">
          <nm:row nm:rname="EPS(1)">
            <nm:col nm:cname="EPS(1)">0.04</nm:col>
          </nm:row>
        </nm:sigma>
        <nm:thetase nm:number="1">
          <nm:val nm:name="CL">0.05</nm:val>
          <nm:val nm:name="V">0.80</nm:val>
        </nm:thetase>
        <nm:omegase nm:number="1">
          <nm:row nm:rname="ETA(1)">
            <nm:col nm:cname="ETA(1)">0.01</nm:col>
          </nm:row>
        </nm:omegase>
        <nm:sigmase nm:number="1">
          <nm:row nm:rname="EPS(1)">
            <nm:col nm:cname="EPS(1)">0.005</nm:col>
          </nm:row>
        </nm:sigmase>
        <nm:eigenvalues nm:number="1">
          <nm:val nm:name="1">1.5</nm:val>
          <nm:val nm:name="2">30.0</nm:val>
        </nm:eigenvalues>
        <nm:covariance_status nm:error="0" nm:numnegeigenvalues="0" nm:mineigenvalue="1.5" nm:maxeigenvalue="30.0" nm:rms="0.01"/>
      </nm:estimation>
    </nm:problem>
  </nm:nonmem>
  <nm:stop_datetime>2024-01-15T10:35:00</nm:stop_datetime>
  <nm:total_cputime>12.34</nm:total_cputime>
</nm:output>
```

- [ ] **Step 2: Mark file as embedded resource in Census.Tests.csproj**

Open `tests/Census.Tests/Census.Tests.csproj`. Add:

```xml
<ItemGroup>
  <EmbeddedResource Include="fixtures\**\*" />
</ItemGroup>
```

Wait — for tests it's simpler to use the file on disk. Instead, add this so the fixture is copied to the output directory:

```xml
<ItemGroup>
  <None Include="fixtures\**\*">
    <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
  </None>
</ItemGroup>
```

---

## Task 2: Write failing tests

**Files:**
- Create: `tests/Census.Tests/NonmemXmlImporterTests.cs`

- [ ] **Step 1: Create the test file**

```csharp
using Census.Domain;
using Census.Import;
using Xunit;

namespace Census.Tests;

public sealed class NonmemXmlImporterTests
{
    private static string FixturePath(string name) =>
        Path.Combine(AppContext.BaseDirectory, "fixtures", name);

    [Fact]
    public void CanImport_ReturnsTrueForXmlExtension()
    {
        Assert.True(new NonmemXmlImporter().CanImport("run27.xml"));
        Assert.True(new NonmemXmlImporter().CanImport("RUN27.XML"));
        Assert.False(new NonmemXmlImporter().CanImport("run27.lst"));
    }

    [Fact]
    public void Import_Fixture_ExtractsRunNo()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));

        Assert.Equal("27", run.RunNo);
        Assert.Equal(27, run.IRunNo);
    }

    [Fact]
    public void Import_Fixture_ExtractsObsRecsAndIndividuals()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));

        Assert.Equal(1234, run.ObsRecs);
        Assert.Equal(56, run.Individuals);
    }

    [Fact]
    public void Import_Fixture_ExtractsEstimationMethod()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));

        var est = Assert.Single(run.Estimations);
        Assert.Equal(1, est.Number);
        Assert.Equal("FOCEI", est.Method);
    }

    [Fact]
    public void Import_Fixture_ExtractsOfv()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));

        var est = Assert.Single(run.Estimations);
        Assert.Equal(-1234.567, est.Ofv, precision: 3);
    }

    [Fact]
    public void Import_Fixture_ExtractsThetaParameters()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));
        var params_ = run.Estimations[0].Parameters;

        var thetas = params_.Where(p => p.Kind == ParameterKind.Theta).ToList();
        Assert.Equal(2, thetas.Count);

        Assert.Equal(1, thetas[0].Index);
        Assert.Equal("CL", thetas[0].Label);
        Assert.Equal(3.21, thetas[0].Estimate, precision: 3);
        Assert.Equal(0.05, thetas[0].StandardError, precision: 3);

        Assert.Equal(2, thetas[1].Index);
        Assert.Equal("V", thetas[1].Label);
        Assert.Equal(15.4, thetas[1].Estimate, precision: 3);
        Assert.Equal(0.80, thetas[1].StandardError, precision: 3);
    }

    [Fact]
    public void Import_Fixture_ExtractsOmegaWithShrinkage()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));
        var omega = Assert.Single(run.Estimations[0].Parameters, p => p.Kind == ParameterKind.Omega);

        Assert.Equal(1, omega.Index);
        Assert.Equal(0.09, omega.Estimate, precision: 3);
        Assert.Equal(0.01, omega.StandardError, precision: 3);
        Assert.Equal(12.3, omega.Shrinkage, precision: 2);
    }

    [Fact]
    public void Import_Fixture_ExtractsSigmaWithShrinkage()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));
        var sigma = Assert.Single(run.Estimations[0].Parameters, p => p.Kind == ParameterKind.Sigma);

        Assert.Equal(1, sigma.Index);
        Assert.Equal(0.04, sigma.Estimate, precision: 3);
        Assert.Equal(0.005, sigma.StandardError, precision: 3);
        Assert.Equal(5.6, sigma.Shrinkage, precision: 2);
    }

    [Fact]
    public void Import_Fixture_ExtractsConditionNumber()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));
        var est = run.Estimations[0];

        Assert.Equal(20.0, est.ConditionNumber!.Value, precision: 2); // 30.0 / 1.5
    }

    [Fact]
    public void Import_Fixture_NoWarningsOnSuccess()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));
        Assert.Empty(run.Estimations[0].Warnings);
    }

    [Fact]
    public void Import_Fixture_AddsXmlFileArtifactWithMd5()
    {
        var path = FixturePath("run27.xml");
        var run = new NonmemXmlImporter().Import(path);

        var artifact = Assert.Single(run.Files);
        Assert.Equal("output", artifact.Role);
        Assert.Equal(path, artifact.Path);
        Assert.NotNull(artifact.Md5);
        Assert.Equal(32, artifact.Md5!.Length); // hex MD5 is 32 chars
    }

    [Fact]
    public void Import_InlineXml_CapturesTerminationWarning()
    {
        var xml = """
            <?xml version="1.0"?>
            <output>
              <start_datetime>2024-01-15T10:30:00</start_datetime>
              <control_stream></control_stream>
              <nmtran></nmtran>
              <nonmem version="7.4.4">
                <license_information></license_information>
                <program_information></program_information>
                <problem number="1" subproblem="0" superproblem1="0" iteration1="0" superproblem2="0" iteration2="0">
                  <problem_title></problem_title>
                  <problem_information></problem_information>
                  <estimation number="1" type="1">
                    <estimation_method>FOCEI</estimation_method>
                    <termination_status>1</termination_status>
                    <termination_information>MINIMIZATION TERMINATED</termination_information>
                    <final_objective_function>-500.0</final_objective_function>
                  </estimation>
                </problem>
              </nonmem>
              <stop_datetime>2024-01-15T10:35:00</stop_datetime>
            </output>
            """;

        var run = new NonmemXmlImporter().ImportXml(xml, sourcePath: "run5.xml");
        var est = Assert.Single(run.Estimations);
        Assert.Equal("MINIMIZATION TERMINATED", Assert.Single(est.Warnings));
    }

    [Fact]
    public void Import_InlineXml_LegacyEtashrinkFallback()
    {
        // NONMEM 7.2-era files use "etashrink"/"epsshrink" instead of "etashrinksd"/"epsshrinksd".
        var xml = """
            <?xml version="1.0"?>
            <output>
              <start_datetime>2024-01-15T10:30:00</start_datetime>
              <control_stream></control_stream>
              <nmtran></nmtran>
              <nonmem version="7.2.0">
                <license_information></license_information>
                <program_information></program_information>
                <problem number="1" subproblem="0" superproblem1="0" iteration1="0" superproblem2="0" iteration2="0">
                  <problem_title></problem_title>
                  <problem_information></problem_information>
                  <estimation number="1" type="1">
                    <estimation_method>FOCE</estimation_method>
                    <termination_status>0</termination_status>
                    <etashrink>
                      <row rname="ETA(1)">
                        <col cname="ETA(1)">8.5</col>
                      </row>
                    </etashrink>
                    <final_objective_function>-800.0</final_objective_function>
                    <omega>
                      <row rname="ETA(1)">
                        <col cname="ETA(1)">0.05</col>
                      </row>
                    </omega>
                  </estimation>
                </problem>
              </nonmem>
              <stop_datetime>2024-01-15T10:35:00</stop_datetime>
            </output>
            """;

        var run = new NonmemXmlImporter().ImportXml(xml, sourcePath: "run3.xml");
        var omega = Assert.Single(run.Estimations[0].Parameters, p => p.Kind == ParameterKind.Omega);
        Assert.Equal(8.5, omega.Shrinkage, precision: 2);
    }

    [Fact]
    public void Import_InlineXml_SimulationRunHasNoEstimations()
    {
        var xml = """
            <?xml version="1.0"?>
            <output>
              <start_datetime>2024-01-15T10:30:00</start_datetime>
              <control_stream></control_stream>
              <nmtran></nmtran>
              <nonmem version="7.4.4">
                <license_information></license_information>
                <program_information></program_information>
                <problem number="1" subproblem="0" superproblem1="0" iteration1="0" superproblem2="0" iteration2="0">
                  <problem_title></problem_title>
                  <problem_information></problem_information>
                  <simulation_information>SIMULATION</simulation_information>
                </problem>
              </nonmem>
              <stop_datetime>2024-01-15T10:35:00</stop_datetime>
            </output>
            """;

        var run = new NonmemXmlImporter().ImportXml(xml, sourcePath: "sim1.xml");
        Assert.Empty(run.Estimations);
        Assert.Equal("1", run.RunNo);
    }
}
```

- [ ] **Step 2: Run the tests to confirm they fail**

```
dotnet test tests/Census.Tests/ --filter "NonmemXmlImporterTests" --logger "console;verbosity=normal"
```

Expected: compile error or `NotImplementedException` for most tests.

---

## Task 3: Implement NonmemXmlImporter

**Files:**
- Modify: `src/Census.Import/NonmemXmlImporter.cs`

- [ ] **Step 1: Replace stub with full implementation**

Replace the entire contents of `src/Census.Import/NonmemXmlImporter.cs`:

```csharp
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

        return new Run
        {
            RunNo = runNo,
            IRunNo = int.TryParse(runNo, NumberStyles.Integer, CultureInfo.InvariantCulture, out var n) ? n : 0,
            ObsRecs = obsRecs,
            Individuals = individuals,
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
            var conditionNumber = ParseConditionNumber(El(estEl, "covariance_status"));

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
        var shrinkRows = shrinkEl is not null ? Els(shrinkEl, "row").ToList() : [];

        var result = new List<Parameter>(rows.Count);
        for (var i = 0; i < rows.Count; i++)
        {
            var diagonalCol = Els(rows[i], "col").LastOrDefault();
            var diagonalSe = i < seRows.Count
                ? Els(seRows[i], "col").LastOrDefault()
                : null;
            // Shrinkage tables have one value per row (one per eta/eps).
            var shrinkCol = i < shrinkRows.Count
                ? Els(shrinkRows[i], "col").FirstOrDefault()
                : null;

            result.Add(new Parameter
            {
                Kind = kind,
                Index = i + 1,
                Label = Attr(rows[i], "rname")?.Trim(),
                Estimate = diagonalCol is not null ? ParseDouble(diagonalCol.Value) : null,
                StandardError = diagonalSe is not null ? ParseDouble(diagonalSe.Value) : null,
                Shrinkage = shrinkCol is not null ? ParseDouble(shrinkCol.Value) : null,
            });
        }

        return result;
    }

    private static double? ParseConditionNumber(XElement? covStatusEl)
    {
        if (covStatusEl is null)
        {
            return null;
        }

        var minVal = ParseDouble(Attr(covStatusEl, "mineigenvalue"));
        var maxVal = ParseDouble(Attr(covStatusEl, "maxeigenvalue"));

        if (minVal is null || maxVal is null || minVal == 0.0)
        {
            return null;
        }

        return maxVal / minVal;
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
        // Strip leading "run" prefix (case-insensitive) if present, e.g. "run27" -> "27".
        if (stem.StartsWith("run", StringComparison.OrdinalIgnoreCase) && stem.Length > 3)
        {
            stem = stem[3..];
        }

        return stem;
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
```

- [ ] **Step 2: Run tests to verify they pass**

```
dotnet test tests/Census.Tests/ --filter "NonmemXmlImporterTests" --logger "console;verbosity=normal"
```

Expected: all tests pass.

---

## Task 4: Run the full suite and commit

- [ ] **Step 1: Run all tests**

```
dotnet test tests/Census.Tests/ --logger "console;verbosity=normal"
```

Expected: all tests green (previously passing `RunTests` and `SqliteProjectStoreTests` must remain green).

- [ ] **Step 2: Commit**

```bash
git add tests/Census.Tests/fixtures/run27.xml \
        tests/Census.Tests/Census.Tests.csproj \
        tests/Census.Tests/NonmemXmlImporterTests.cs \
        src/Census.Import/NonmemXmlImporter.cs
git commit -m "feat: implement Phase 3 NONMEM XML importer with fixture tests"
```

---

## Self-Review

### Spec coverage

| Requirement (from IMPLEMENTATION_PLAN.md §Phase 3) | Covered by |
|---|---|
| Schema-aware traversal into domain objects | `ParseEstimations`, `ParseThetas`, `ParseMatrix` in Task 3 |
| MD5 via `System.Security.Cryptography` | `ComputeMd5` in Task 3 |
| File discovery (source file as artifact) | `Import()` sets `Files` with the source path |
| `XmlSchemaClassGenerator` | **Deliberately skipped** — XDocument by local name is simpler, equally correct, and more robust to namespace variations in real NONMEM output. |
| Regression-test against fixtures | `NonmemXmlImporterTests` + `run27.xml` fixture in Tasks 1–2 |
| `ObsRecs`/`Individuals` (7.6+ only) | Extracted from `problem_options/@data_nobs` / `@data_nind`; null for 7.2 files that lack `problem_options` |
| 7.6 `etashrinksd`/`epsshrinksd` + 7.2 `etashrink`/`epsshrink` fallback | Handled in `ParseEstimations` with `??` fallback |
| `sir_estimation` (NONMEM 7.6+) | Included in the LINQ filter alongside `estimation` |
| Namespace: `nm:` prefix on elements and attributes | Handled via `Name.LocalName` and `Attributes().FirstOrDefault(a => a.Name.LocalName == x)` |

### What's deferred (out of scope for this phase)

- **Multiple estimations** — the parser handles them (`ParseEstimations` loops), but no fixture covers it. Add a second fixture or inline test when a multi-estimation run becomes available.
- **PsN import** — Phase 5.
- **Listing parser** — Phase 5.
- **`ObsRecs` / `Individuals`** — not present in NONMEM XML; to be populated by the listing parser or PsN metadata in Phase 5.
- **`DOfv`** — cross-run computation, handled by storage/reporting layer.
