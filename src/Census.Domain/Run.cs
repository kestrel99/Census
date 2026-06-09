namespace Census.Domain;

/// <summary>
/// A single NONMEM run as tracked by Census. This is the behavioral center of the
/// application; values here are what the importers populate and the reports read.
/// </summary>
public sealed record Run
{
    /// <summary>User-facing run number (text, e.g. "1", "27a").</summary>
    public required string RunNo { get; init; }

    /// <summary>Numeric run number used for ordering.</summary>
    public int IRunNo { get; init; }

    /// <summary>Parent run number, if this run was derived from another.</summary>
    public string? ParentNo { get; init; }

    /// <summary>Objective function value.</summary>
    public double? Ofv { get; init; }

    /// <summary>User comment.</summary>
    public string? Comment { get; init; }

    /// <summary>Whether the user flagged this as a key run.</summary>
    public bool KeyRun { get; init; }

    public IReadOnlyList<Parameter> Thetas { get; init; } = [];
    public IReadOnlyList<Parameter> Omegas { get; init; } = [];
    public IReadOnlyList<Parameter> Sigmas { get; init; } = [];
}

/// <summary>An estimated parameter (theta/omega/sigma) with optional standard error.</summary>
public sealed record Parameter
{
    public required string Label { get; init; }
    public double Estimate { get; init; }
    public double? StandardError { get; init; }
}
