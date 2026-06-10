using System.Globalization;
using Census.Domain;
using Census.Reports;
using Xunit;

namespace Census.Tests;

public class CsvReportWriterTests
{
    private static readonly CsvReportWriter Writer = new();

    // -----------------------------------------------------------------------
    // Test 1: header row is present and correct
    // -----------------------------------------------------------------------
    [Fact]
    public void Render_SingleEstimation_HeaderRowPresent()
    {
        var run = new Run
        {
            RunNo = "1",
            Estimations = [new Estimation { Number = 1 }],
        };

        string csv = Writer.Render(run);
        string firstLine = csv.Split('\n')[0];

        Assert.Equal("RunNo,EstNo,Method,OFV,Kind,Index,Label,Estimate,SE,RSE_Pct,CI_Lower,CI_Upper,Shrinkage_Pct", firstLine);
    }

    // -----------------------------------------------------------------------
    // Test 2: theta row values
    // -----------------------------------------------------------------------
    [Fact]
    public void Render_SingleEstimation_ThetaRowValues()
    {
        var run = new Run
        {
            RunNo = "27",
            Estimations =
            [
                new Estimation
                {
                    Number = 1,
                    Method = "FOCEI",
                    Ofv = -1234.567,
                    Parameters =
                    [
                        new Parameter
                        {
                            Kind = ParameterKind.Theta,
                            Index = 1,
                            Label = "CL",
                            Estimate = 3.21,
                            StandardError = 0.05,
                        },
                    ],
                },
            ],
        };

        string csv = Writer.Render(run);
        string[] lines = csv.Split('\n', StringSplitOptions.RemoveEmptyEntries);

        // lines[0] = header, lines[1] = first data row
        Assert.True(lines.Length >= 2, "Expected at least a header and one data row.");

        string[] row = lines[1].Split(',');

        const int iRunNo       = 0;
        const int iEstNo       = 1;
        const int iMethod      = 2;
        const int iOfv         = 3;
        const int iKind        = 4;
        const int iIndex       = 5;
        const int iLabel       = 6;
        const int iEstimate    = 7;
        const int iSe          = 8;
        const int iRsePct      = 9;
        const int iShrinkage   = 12;

        Assert.Equal("27",    row[iRunNo]);
        Assert.Equal("1",     row[iEstNo]);
        Assert.Equal("FOCEI", row[iMethod]);
        Assert.Equal("-1234.57", row[iOfv]);
        Assert.Equal("THETA", row[iKind]);
        Assert.Equal("1",     row[iIndex]);
        Assert.Equal("CL",    row[iLabel]);
        Assert.Equal("3.21",  row[iEstimate]);
        Assert.Equal("0.05",  row[iSe]);

        // RSE should parse as a positive number
        Assert.True(double.Parse(row[iRsePct], CultureInfo.InvariantCulture) > 0,
            $"RSE_Pct should be positive, got '{row[iRsePct]}'");

        // Theta has no shrinkage
        Assert.Equal(string.Empty, row[iShrinkage]);
    }

    // -----------------------------------------------------------------------
    // Test 3: omega with shrinkage populates Shrinkage_Pct column
    // -----------------------------------------------------------------------
    [Fact]
    public void Render_OmegaWithShrinkage_ShrinkageColumnPopulated()
    {
        var run = new Run
        {
            RunNo = "1",
            Estimations =
            [
                new Estimation
                {
                    Number = 1,
                    Parameters =
                    [
                        new Parameter
                        {
                            Kind = ParameterKind.Omega,
                            Index = 1,
                            Estimate = 0.04,
                            Shrinkage = 12.3,
                        },
                    ],
                },
            ],
        };

        string csv = Writer.Render(run);
        string[] lines = csv.Split('\n', StringSplitOptions.RemoveEmptyEntries);

        Assert.True(lines.Length >= 2);

        string[] row = lines[1].Split(',');
        const int iShrinkage = 12;

        Assert.False(string.IsNullOrEmpty(row[iShrinkage]),
            "Shrinkage_Pct should be non-empty for an omega with shrinkage.");

        double shrinkageValue = double.Parse(row[iShrinkage], CultureInfo.InvariantCulture);
        Assert.Equal(12.3, shrinkageValue, precision: 4);
    }

    // -----------------------------------------------------------------------
    // Test 4: run with no estimations produces header only
    // -----------------------------------------------------------------------
    [Fact]
    public void Render_NoEstimations_HeaderOnly()
    {
        var run = new Run { RunNo = "1" };

        string csv = Writer.Render(run);

        // Strip trailing whitespace/newlines before splitting
        string[] lines = csv.Trim().Split('\n', StringSplitOptions.RemoveEmptyEntries);

        Assert.Single(lines);
        Assert.StartsWith("RunNo,", lines[0]);
    }

    // -----------------------------------------------------------------------
    // Test 5: null SE → RSE_Pct, CI_Lower, CI_Upper are empty
    // -----------------------------------------------------------------------
    [Fact]
    public void Render_NullSE_RseAndCiAreEmpty()
    {
        var run = new Run
        {
            RunNo = "1",
            Estimations =
            [
                new Estimation
                {
                    Number = 1,
                    Parameters =
                    [
                        new Parameter
                        {
                            Kind = ParameterKind.Theta,
                            Index = 1,
                            Estimate = 5.0,
                            StandardError = null,
                        },
                    ],
                },
            ],
        };

        string csv = Writer.Render(run);
        string[] lines = csv.Split('\n', StringSplitOptions.RemoveEmptyEntries);

        Assert.True(lines.Length >= 2);

        string[] row = lines[1].Split(',');

        const int iRsePct  = 9;
        const int iCiLower = 10;
        const int iCiUpper = 11;

        Assert.Equal(string.Empty, row[iRsePct]);
        Assert.Equal(string.Empty, row[iCiLower]);
        Assert.Equal(string.Empty, row[iCiUpper]);
    }
}
