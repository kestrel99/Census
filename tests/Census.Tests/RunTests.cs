using Census.Domain;
using Xunit;

namespace Census.Tests;

public class RunTests
{
    [Fact]
    public void Run_RetainsCoreIdentity()
    {
        var run = new Run
        {
            RunNo = "27",
            IRunNo = 27,
            ParentNo = "12",
            Ofv = -1234.56,
        };

        Assert.Equal("27", run.RunNo);
        Assert.Equal(27, run.IRunNo);
        Assert.Equal("12", run.ParentNo);
        Assert.Equal(-1234.56, run.Ofv);
        Assert.Empty(run.Thetas);
    }
}
