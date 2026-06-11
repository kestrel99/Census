using Census.Domain;
using Census.Reports;
using VerifyXunit;
using Xunit;

namespace Census.Tests;

public sealed class HtmlReportWriterTests : VerifyBase
{
    public HtmlReportWriterTests() : base()
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
        var result = new HtmlReportWriter().Render(MakeRun());
        return Verify(result);
    }

    [Fact]
    public void Render_ContainsKeyValues()
    {
        var result = new HtmlReportWriter().Render(MakeRun());
        Assert.Contains("Run 27", result);
        Assert.Contains("FOCEI", result);
        Assert.Contains("CL", result);
        Assert.Contains("3.21", result);
        Assert.Contains("12.3", result); // shrinkage
    }

    [Fact]
    public void Render_EmptyEstimations_ProducesValidHtml()
    {
        var run = new Run { RunNo = "99", Estimations = [] };
        var result = new HtmlReportWriter().Render(run);
        Assert.Contains("<!DOCTYPE html>", result);
        Assert.Contains("Run 99", result);
    }
}
