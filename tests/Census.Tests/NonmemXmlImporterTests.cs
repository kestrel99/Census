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
        Assert.Equal(-1234.567, est.Ofv!.Value, precision: 3);
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
        Assert.Equal(3.21, thetas[0].Estimate!.Value, precision: 3);
        Assert.Equal(0.05, thetas[0].StandardError!.Value, precision: 3);

        Assert.Equal(2, thetas[1].Index);
        Assert.Equal("V", thetas[1].Label);
        Assert.Equal(15.4, thetas[1].Estimate!.Value, precision: 3);
        Assert.Equal(0.80, thetas[1].StandardError!.Value, precision: 3);
    }

    [Fact]
    public void Import_Fixture_ExtractsOmegaWithShrinkage()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));
        var omega = Assert.Single(run.Estimations[0].Parameters, p => p.Kind == ParameterKind.Omega);

        Assert.Equal(1, omega.Index);
        Assert.Equal(0.09, omega.Estimate!.Value, precision: 3);
        Assert.Equal(0.01, omega.StandardError!.Value, precision: 3);
        Assert.Equal(12.3, omega.Shrinkage!.Value, precision: 2);
    }

    [Fact]
    public void Import_Fixture_ExtractsSigmaWithShrinkage()
    {
        var run = new NonmemXmlImporter().Import(FixturePath("run27.xml"));
        var sigma = Assert.Single(run.Estimations[0].Parameters, p => p.Kind == ParameterKind.Sigma);

        Assert.Equal(1, sigma.Index);
        Assert.Equal(0.04, sigma.Estimate!.Value, precision: 3);
        Assert.Equal(0.005, sigma.StandardError!.Value, precision: 3);
        Assert.Equal(5.6, sigma.Shrinkage!.Value, precision: 2);
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

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "run5.xml");
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

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "run3.xml");
        var omega = Assert.Single(run.Estimations[0].Parameters, p => p.Kind == ParameterKind.Omega);
        Assert.Equal(8.5, omega.Shrinkage!.Value, precision: 2);
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

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "sim1.xml");
        Assert.Empty(run.Estimations);
        Assert.Equal("1", run.RunNo);
    }

    [Fact]
    public void Import_InlineXml_ComputesConditionNumberFromCorrelationMatrix()
    {
        // NM 7.3-style output: no <eigenvalues>, covariance_status eigenvalues zeroed,
        // but a <correlation> matrix is present. The 2x2 correlation matrix [[1,0.5],[0.5,1]]
        // has eigenvalues 1.5 and 0.5, so the condition number is 3.0.
        var xml = """
            <?xml version="1.0" encoding="ASCII"?>
            <nm:output xmlns:nm="http://namespaces.oreilly.com/xmlnut/address">
              <nm:nonmem nm:version='7.3.0'>
                <nm:problem nm:number='1'>
                  <nm:estimation nm:number='1' nm:type='0'>
                    <nm:estimation_method>focei</nm:estimation_method>
                    <nm:termination_status>0</nm:termination_status>
                    <nm:final_objective_function>-100.0</nm:final_objective_function>
                    <nm:covariance_status nm:error='0' nm:numnegeigenvalues='-1' nm:mineigenvalue='0.0' nm:maxeigenvalue='0.0' nm:rms='0.0'/>
                    <nm:correlation>
                      <nm:row nm:rname='THETA1'>
                        <nm:col nm:cname='THETA1'>0.10</nm:col>
                      </nm:row>
                      <nm:row nm:rname='THETA2'>
                        <nm:col nm:cname='THETA1'>0.50</nm:col>
                        <nm:col nm:cname='THETA2'>0.20</nm:col>
                      </nm:row>
                    </nm:correlation>
                  </nm:estimation>
                </nm:problem>
              </nm:nonmem>
            </nm:output>
            """;

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "runR010.xml");
        var est = Assert.Single(run.Estimations);
        Assert.Equal(3.0, est.ConditionNumber!.Value, precision: 6);
    }

    [Fact]
    public void Import_IndexesSiblingRunFilesByPath()
    {
        var dir = Path.Combine(Path.GetTempPath(), "census-import-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(dir);
        try
        {
            File.WriteAllText(Path.Combine(dir, "run1.ctl"), "$PROBLEM\n$DATA data1.csv IGNORE=@\n");
            File.WriteAllText(Path.Combine(dir, "run1.ext"), "x");
            File.WriteAllText(Path.Combine(dir, "run1.cov"), "x");
            File.WriteAllText(Path.Combine(dir, "sdtab1"), "x");
            File.WriteAllText(Path.Combine(dir, "data1.csv"), "ID,DV\n1,2\n");

            var xml = """
                <?xml version="1.0"?>
                <output>
                  <control_stream>$PROBLEM
                $DATA data1.csv IGNORE=@</control_stream>
                  <nonmem version="7.4.0">
                    <problem number="1">
                      <estimation number="1">
                        <estimation_method>FOCEI</estimation_method>
                        <final_objective_function>-1.0</final_objective_function>
                      </estimation>
                    </problem>
                  </nonmem>
                </output>
                """;
            var xmlPath = Path.Combine(dir, "run1.xml");
            File.WriteAllText(xmlPath, xml);

            var run = new NonmemXmlImporter().Import(xmlPath);
            var roles = run.Files.Select(f => f.Role).ToList();

            Assert.Contains("output", roles);   // the .xml itself
            Assert.Contains("model", roles);     // run1.ctl
            Assert.Contains("ext", roles);       // run1.ext
            Assert.Contains("cov", roles);       // run1.cov
            Assert.Contains("table", roles);     // sdtab1
            Assert.Contains("data", roles);      // data1.csv via $DATA

            // Paths are recorded; the data file resolves to the sibling csv.
            Assert.Contains(run.Files, f => f.Role == "data" && f.Path.EndsWith("data1.csv", StringComparison.Ordinal));
        }
        finally
        {
            Directory.Delete(dir, recursive: true);
        }
    }

    [Fact]
    public void Import_InlineXml_ParsesCovarianceAndCorrelationMatrices()
    {
        var xml = """
            <?xml version="1.0" encoding="ASCII"?>
            <nm:output xmlns:nm="http://namespaces.oreilly.com/xmlnut/address">
              <nm:nonmem nm:version='7.3.0'>
                <nm:problem nm:number='1'>
                  <nm:estimation nm:number='1' nm:type='0'>
                    <nm:estimation_method>focei</nm:estimation_method>
                    <nm:termination_status>0</nm:termination_status>
                    <nm:final_objective_function>-100.0</nm:final_objective_function>
                    <nm:covariance>
                      <nm:row nm:rname='THETA1'><nm:col nm:cname='THETA1'>0.04</nm:col></nm:row>
                      <nm:row nm:rname='THETA2'><nm:col nm:cname='THETA1'>0.01</nm:col><nm:col nm:cname='THETA2'>0.09</nm:col></nm:row>
                    </nm:covariance>
                    <nm:correlation>
                      <nm:row nm:rname='THETA1'><nm:col nm:cname='THETA1'>0.20</nm:col></nm:row>
                      <nm:row nm:rname='THETA2'><nm:col nm:cname='THETA1'>0.17</nm:col><nm:col nm:cname='THETA2'>0.30</nm:col></nm:row>
                    </nm:correlation>
                  </nm:estimation>
                </nm:problem>
              </nm:nonmem>
            </nm:output>
            """;

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "runR012.xml");
        var est = Assert.Single(run.Estimations);

        Assert.NotNull(est.Covariance);
        Assert.Equal(["THETA1", "THETA2"], est.Covariance!.Labels);
        Assert.Equal(0.04, est.Covariance.Values[0][0]!.Value, precision: 6);
        Assert.Equal(0.01, est.Covariance.Values[1][0]!.Value, precision: 6);
        Assert.Equal(0.09, est.Covariance.Values[1][1]!.Value, precision: 6);

        Assert.NotNull(est.Correlation);
        Assert.Equal(0.17, est.Correlation!.Values[1][0]!.Value, precision: 6);
    }

    [Fact]
    public void Import_InlineXml_ConditionNumber_EquicorrelationMatrix3x3()
    {
        // A 3x3 correlation matrix with 1 on the diagonal and 0.5 off-diagonal has
        // eigenvalues 1+(n-1)*rho = 2.0 and 1-rho = 0.5 (x2), so condition number = 4.0.
        // (Diagonal values below are standard errors, which the importer replaces with 1.)
        var xml = """
            <?xml version="1.0" encoding="ASCII"?>
            <nm:output xmlns:nm="http://namespaces.oreilly.com/xmlnut/address">
              <nm:nonmem nm:version='7.3.0'>
                <nm:problem nm:number='1'>
                  <nm:estimation nm:number='1' nm:type='0'>
                    <nm:estimation_method>focei</nm:estimation_method>
                    <nm:termination_status>0</nm:termination_status>
                    <nm:final_objective_function>-100.0</nm:final_objective_function>
                    <nm:correlation>
                      <nm:row nm:rname='T1'><nm:col nm:cname='T1'>0.10</nm:col></nm:row>
                      <nm:row nm:rname='T2'><nm:col nm:cname='T1'>0.50</nm:col><nm:col nm:cname='T2'>0.20</nm:col></nm:row>
                      <nm:row nm:rname='T3'><nm:col nm:cname='T1'>0.50</nm:col><nm:col nm:cname='T2'>0.50</nm:col><nm:col nm:cname='T3'>0.30</nm:col></nm:row>
                    </nm:correlation>
                  </nm:estimation>
                </nm:problem>
              </nm:nonmem>
            </nm:output>
            """;

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "runR011.xml");
        var est = Assert.Single(run.Estimations);
        Assert.Equal(4.0, est.ConditionNumber!.Value, precision: 6);
    }

    [Fact]
    public void Import_InlineXml_CapturesTimingsAndProblemTitleComment()
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
                  <problem_title>One-compartment base model</problem_title>
                  <problem_information></problem_information>
                  <estimation number="1" type="1">
                    <estimation_method>FOCEI</estimation_method>
                    <termination_status>0</termination_status>
                    <final_objective_function>-500.0</final_objective_function>
                    <estimation_elapsed_time>123.4</estimation_elapsed_time>
                    <covariance_elapsed_time>45.6</covariance_elapsed_time>
                  </estimation>
                  <post_process_times>
                    <post_elapsed_time>1.5</post_elapsed_time>
                    <finaloutput_elapsed_time>0.7</finaloutput_elapsed_time>
                  </post_process_times>
                </problem>
              </nonmem>
              <stop_datetime>2024-01-15T10:45:00</stop_datetime>
              <total_cputime>900.0</total_cputime>
            </output>
            """;

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "run9.xml");

        Assert.Equal("One-compartment base model", run.Comment);
        Assert.Equal("2024-01-15T10:30:00", run.StartDateTime);
        Assert.Equal("2024-01-15T10:45:00", run.StopDateTime);
        Assert.Equal(900.0, run.TotalCpuTime!.Value, precision: 3);
        Assert.Equal(1.5, run.PostElapsedTime!.Value, precision: 3);
        Assert.Equal(0.7, run.FinalOutputElapsedTime!.Value, precision: 3);

        var est = Assert.Single(run.Estimations);
        Assert.Equal(123.4, est.EstimationTime!.Value, precision: 3);
        Assert.Equal(45.6, est.CovarianceTime!.Value, precision: 3);
    }

    [Fact]
    public void Import_InlineXml_FlatShrinkageRowFormat()
    {
        // NM 7.3–7.5 write shrinkage as one SUBPOP row with one col per eta,
        // not one row per eta. Both etas must get their shrinkage values.
        var xml = """
            <?xml version="1.0" encoding="ASCII"?>
            <nm:output xmlns:nm="http://namespaces.oreilly.com/xmlnut/address">
              <nm:nonmem nm:version='7.3.0'>
                <nm:problem nm:number='1'>
                  <nm:estimation nm:number='1' nm:type='0'>
                    <nm:estimation_method>focei</nm:estimation_method>
                    <nm:termination_status>0</nm:termination_status>
                    <nm:etashrink>
                      <nm:row nm:rname='SUBPOP1'>
                        <nm:col nm:cname='ETA1'>1.37</nm:col>
                        <nm:col nm:cname='ETA2'>1.46</nm:col>
                      </nm:row>
                    </nm:etashrink>
                    <nm:epsshrink>
                      <nm:row nm:rname='SUBPOP1'>
                        <nm:col nm:cname='EPS1'>5.22</nm:col>
                      </nm:row>
                    </nm:epsshrink>
                    <nm:final_objective_function>-4126.11</nm:final_objective_function>
                    <nm:omega>
                      <nm:row nm:rname='1'>
                        <nm:col nm:cname='1'>0.0716</nm:col>
                      </nm:row>
                      <nm:row nm:rname='2'>
                        <nm:col nm:cname='1'>0.0</nm:col>
                        <nm:col nm:cname='2'>0.0922</nm:col>
                      </nm:row>
                    </nm:omega>
                    <nm:sigma>
                      <nm:row nm:rname='1'>
                        <nm:col nm:cname='1'>1.0</nm:col>
                      </nm:row>
                    </nm:sigma>
                  </nm:estimation>
                </nm:problem>
              </nm:nonmem>
            </nm:output>
            """;

        var run = NonmemXmlImporter.ImportXml(xml, sourcePath: "runR001.xml");
        var est = Assert.Single(run.Estimations);

        var omegas = est.Parameters.Where(p => p.Kind == ParameterKind.Omega).ToList();
        Assert.Equal(2, omegas.Count);
        Assert.Equal(1.37, omegas[0].Shrinkage!.Value, precision: 2);
        Assert.Equal(1.46, omegas[1].Shrinkage!.Value, precision: 2);

        var sigma = Assert.Single(est.Parameters, p => p.Kind == ParameterKind.Sigma);
        Assert.Equal(5.22, sigma.Shrinkage!.Value, precision: 2);
    }
}
