using System.Runtime.InteropServices;
using Census.ExternalTools;

namespace Census.Tests;

public sealed class ExternalToolRunnerTests
{
    private readonly ProcessRunner _runner = new();

    [Fact]
    public void Run_EchoCommand_ReturnsZero()
    {
        int exitCode;
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            exitCode = _runner.Run("cmd.exe", ["/c", "echo", "hello"]);
        }
        else
        {
            exitCode = _runner.Run("echo", ["hello"]);
        }

        Assert.Equal(0, exitCode);
    }

    [Fact]
    public void Run_InvalidExecutable_ThrowsException()
    {
        Assert.ThrowsAny<Exception>(() =>
            _runner.Run("this_executable_does_not_exist_census_test", []));
    }

    [Fact]
    public void Run_WithWorkingDirectory_Succeeds()
    {
        int exitCode;
        string workingDirectory = AppContext.BaseDirectory;

        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            exitCode = _runner.Run("cmd.exe", ["/c", "echo", "hello"], workingDirectory);
        }
        else
        {
            exitCode = _runner.Run("echo", ["hello"], workingDirectory);
        }

        Assert.Equal(0, exitCode);
    }
}
