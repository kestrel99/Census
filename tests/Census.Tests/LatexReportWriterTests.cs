using Census.Domain;
using Census.Reports;
using VerifyXunit;
using Xunit;

namespace Census.Tests;

public sealed class LatexReportWriterTests : VerifyBase
{
    public LatexReportWriterTests() : base()
    {
    }

    private static Run MakeRun() => new Run
    {
        RunNo = "27",
        ObsRecs = 1234,
        Individuals = 56,
        Estimations = [new Estimation
        {
            Number = 1,
            Method = "FOCEI",
            Ofv = -1234.567,
            ConditionNumber = 20.0,
            Parameters = [
                new Parameter { Kind = ParameterKind.Theta, Index = 1, Label = "CL", Estimate = 3.21, StandardError = 0.05 },
                new Parameter { Kind = ParameterKind.Theta, Index = 2, Label = "V",  Estimate = 15.4, StandardError = 0.80 },
                new Parameter { Kind = ParameterKind.Omega, Index = 1, Estimate = 0.09, StandardError = 0.01, Shrinkage = 12.3 },
                new Parameter { Kind = ParameterKind.Sigma, Index = 1, Estimate = 0.04, StandardError = 0.005, Shrinkage = 5.6 },
            ],
        }],
    };

    [Fact]
    public Task Render_SingleEstimation_MatchesSnapshot()
    {
        var result = new LatexReportWriter().Render(MakeRun());
        return Verify(result);
    }

    [Fact]
    public void Render_ContainsKeyValues()
    {
        var result = new LatexReportWriter().Render(MakeRun());
        Assert.Contains(@"\section*{Run 27}", result);
        Assert.Contains("FOCEI", result);
        Assert.Contains("CL", result);
        Assert.Contains("3.21", result);
        Assert.Contains("12.3", result); // shrinkage
    }

    [Fact]
    public void Render_LatexEscapesSpecialChars()
    {
        var run = new Run
        {
            RunNo = "run_27",
            Estimations = [new Estimation
            {
                Number = 1,
                Parameters = [
                    new Parameter { Kind = ParameterKind.Theta, Index = 1, Label = "CL%50", Estimate = 1.0, StandardError = 0.1 },
                ],
            }],
        };
        var result = new LatexReportWriter().Render(run);
        Assert.Contains(@"run\_27", result);
        Assert.Contains(@"CL\%50", result);
    }

    [Fact]
    public void Render_EmptyEstimations_ProducesDocument()
    {
        var run = new Run { RunNo = "99", Estimations = [] };
        var result = new LatexReportWriter().Render(run);
        Assert.Contains(@"\documentclass", result);
        Assert.Contains(@"\end{document}", result);
    }
}
