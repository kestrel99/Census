namespace Census.Domain;

/// <summary>
/// Derived objective-function quantities. dOFV is always computed against a chosen reference run
/// (the parent in the run grid/list, the first selected run in Compare) and is never stored, so it
/// cannot go stale when a parent changes or a run is re-imported.
/// </summary>
public static class OfvAnalysis
{
    /// <summary>OFV of the final estimation step, or null if the run has no estimation/OFV.</summary>
    public static double? FinalOfv(this Run run) =>
        run.Estimations.Count > 0 ? run.Estimations[^1].Ofv : null;

    /// <summary>
    /// dOFV = OFV(<paramref name="run"/>) − OFV(<paramref name="reference"/>), using each run's
    /// final-step OFV. Null when either OFV is missing or no reference is given.
    /// </summary>
    public static double? DeltaOfv(Run run, Run? reference) =>
        run.FinalOfv() is { } a && reference?.FinalOfv() is { } b ? a - b : null;
}
