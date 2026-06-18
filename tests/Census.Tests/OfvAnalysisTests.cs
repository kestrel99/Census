using Census.Domain;
using Xunit;

namespace Census.Tests;

public sealed class OfvAnalysisTests
{
    private static Run RunWithOfv(string runNo, double? ofv) => new()
    {
        RunNo = runNo,
        Estimations = ofv is null
            ? []
            : [new Estimation { Number = 1, Method = "FOCEI", Ofv = ofv }],
    };

    [Fact]
    public void FinalOfv_UsesLastEstimation_OrNull()
    {
        var run = new Run
        {
            RunNo = "1",
            Estimations =
            [
                new Estimation { Number = 1, Ofv = -100.0 },
                new Estimation { Number = 2, Ofv = -150.0 },
            ],
        };

        Assert.Equal(-150.0, run.FinalOfv());
        Assert.Null(RunWithOfv("2", null).FinalOfv());
    }

    [Fact]
    public void DeltaOfv_IsRunMinusReference()
    {
        var child = RunWithOfv("2", -150.0);
        var parent = RunWithOfv("1", -100.0);

        Assert.Equal(-50.0, OfvAnalysis.DeltaOfv(child, parent));
    }

    [Fact]
    public void DeltaOfv_NullWhenReferenceMissingOrNoOfv()
    {
        var child = RunWithOfv("2", -150.0);

        Assert.Null(OfvAnalysis.DeltaOfv(child, reference: null));
        Assert.Null(OfvAnalysis.DeltaOfv(child, RunWithOfv("1", null)));
        Assert.Null(OfvAnalysis.DeltaOfv(RunWithOfv("2", null), RunWithOfv("1", -100.0)));
    }
}
