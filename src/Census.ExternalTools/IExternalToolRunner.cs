namespace Census.ExternalTools;

/// <summary>
/// Launches external tools (NONMEM, PsN, Perl, R) via System.Diagnostics.Process.
/// R is driven by writing commands to standard input, matching the current behavior.
/// </summary>
public interface IExternalToolRunner
{
    /// <summary>Run a tool and return its exit code.</summary>
    int Run(string executable, IReadOnlyList<string> arguments, string? workingDirectory = null);
}
