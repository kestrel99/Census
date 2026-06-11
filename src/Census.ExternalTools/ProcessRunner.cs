using System.Diagnostics;

namespace Census.ExternalTools;

/// <summary>
/// Launches external tools via <see cref="System.Diagnostics.Process"/>.
/// </summary>
public sealed class ProcessRunner : IExternalToolRunner
{
    /// <inheritdoc/>
    public int Run(string executable, IReadOnlyList<string> arguments, string? workingDirectory = null)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = executable,
            Arguments = string.Join(" ", arguments.Select(a => a.Contains(' ') ? $"\"{a}\"" : a)),
            WorkingDirectory = workingDirectory ?? Directory.GetCurrentDirectory(),
            UseShellExecute = false,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            CreateNoWindow = false,
        };

        var process = Process.Start(startInfo)!;
        process.WaitForExit();
        return process.ExitCode;
    }
}
