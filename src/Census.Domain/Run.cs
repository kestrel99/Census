namespace Census.Domain;

/// <summary>
/// A single NONMEM run as tracked by Census. This is the behavioral center of the
/// application: importers populate it and reports read from it.
/// </summary>
public sealed record Run
{
    /// <summary>User-facing run number (text, e.g. "1", "27a").</summary>
    public required string RunNo { get; init; }

    /// <summary>Numeric run number used for ordering.</summary>
    public int IRunNo { get; init; }

    /// <summary>Parent run number, if this run was derived from another.</summary>
    public string? ParentNo { get; init; }

    /// <summary>User comment.</summary>
    public string? Comment { get; init; }

    /// <summary>User flag colour: 0 = unflagged, 1-5 = colour index (red/orange/yellow/green/blue).</summary>
    public int Flag { get; init; }

    /// <summary>Number of observation records in the dataset.</summary>
    public int? ObsRecs { get; init; }

    /// <summary>Number of individuals in the dataset.</summary>
    public int? Individuals { get; init; }

    /// <summary>Run start timestamp (NONMEM <c>start_datetime</c>), as reported in the output.</summary>
    public string? StartDateTime { get; init; }

    /// <summary>Run stop timestamp (NONMEM <c>stop_datetime</c>), as reported in the output.</summary>
    public string? StopDateTime { get; init; }

    /// <summary>Total CPU time in seconds (NONMEM <c>total_cputime</c>).</summary>
    public double? TotalCpuTime { get; init; }

    /// <summary>Post-processing elapsed time in seconds (NONMEM <c>post_elapsed_time</c>).</summary>
    public double? PostElapsedTime { get; init; }

    /// <summary>Final-output elapsed time in seconds (NONMEM <c>finaloutput_elapsed_time</c>).</summary>
    public double? FinalOutputElapsedTime { get; init; }

    /// <summary>Estimation steps in this run (NONMEM may run several methods).</summary>
    public IReadOnlyList<Estimation> Estimations { get; init; } = [];

    /// <summary>Files associated with the run (model, control stream, output, tables…).</summary>
    public IReadOnlyList<FileArtifact> Files { get; init; } = [];
}

/// <summary>One estimation step (method) within a run.</summary>
public sealed record Estimation
{
    /// <summary>1-based position of this estimation within the run.</summary>
    public int Number { get; init; }

    /// <summary>Estimation method (e.g. "FOCEI", "IMP", "SAEM").</summary>
    public string? Method { get; init; }

    /// <summary>Objective function value.</summary>
    public double? Ofv { get; init; }

    /// <summary>Condition number of the covariance step, if available.</summary>
    public double? ConditionNumber { get; init; }

    /// <summary>Estimation elapsed time in seconds (NONMEM <c>estimation_elapsed_time</c>).</summary>
    public double? EstimationTime { get; init; }

    /// <summary>Covariance-step elapsed time in seconds (NONMEM <c>covariance_elapsed_time</c>).</summary>
    public double? CovarianceTime { get; init; }

    /// <summary>Variance-covariance matrix of the estimates, if a covariance step ran.</summary>
    public NamedMatrix? Covariance { get; init; }

    /// <summary>Correlation matrix of the estimates (SE on the diagonal), if available.</summary>
    public NamedMatrix? Correlation { get; init; }

    public IReadOnlyList<Parameter> Parameters { get; init; } = [];

    public IReadOnlyList<string> Warnings { get; init; } = [];
}

/// <summary>
/// A labelled lower-triangular symmetric matrix (covariance/correlation of the estimates).
/// <see cref="Values"/>[i] holds the i+1 entries of row i (columns 0..i).
/// </summary>
public sealed record NamedMatrix
{
    public required IReadOnlyList<string> Labels { get; init; }

    public required IReadOnlyList<IReadOnlyList<double?>> Values { get; init; }
}

public enum ParameterKind
{
    Theta,
    Omega,
    Sigma,
}

/// <summary>An estimated parameter (theta/omega/sigma) for a given estimation.</summary>
public sealed record Parameter
{
    public ParameterKind Kind { get; init; }

    /// <summary>1-based index within its kind (THETA 1, OMEGA 1, …).</summary>
    public int Index { get; init; }

    public string? Label { get; init; }

    public double? Estimate { get; init; }

    public double? StandardError { get; init; }

    /// <summary>Eta/epsilon shrinkage, for omegas/sigmas.</summary>
    public double? Shrinkage { get; init; }
}

/// <summary>A file associated with a run, with an optional content hash.</summary>
public sealed record FileArtifact
{
    /// <summary>Logical role: model, ctl, data, output, ext, cov, sdtab, patab…</summary>
    public required string Role { get; init; }

    public required string Path { get; init; }

    public string? Md5 { get; init; }
}
