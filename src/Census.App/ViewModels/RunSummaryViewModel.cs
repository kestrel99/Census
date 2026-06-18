using Avalonia.Media;
using Census.Domain;

namespace Census.App.ViewModels;

public sealed class RunSummaryViewModel
{
    public Run Model { get; }

    public RunSummaryViewModel(Run run, IReadOnlyDictionary<string, Run> allByRunNo)
    {
        Model = run;

        var lastEst = run.Estimations.Count > 0 ? run.Estimations[^1] : null;
        RunNo = run.RunNo;
        ParentNo = run.ParentNo ?? string.Empty;
        Comment = run.Comment ?? string.Empty;
        Method = lastEst?.Method ?? string.Empty;
        Ofv = lastEst?.Ofv?.ToString("0.000", System.Globalization.CultureInfo.InvariantCulture) ?? string.Empty;

        // dOFV is derived against the parent run (never stored). See Census.Domain.OfvAnalysis.
        var parent = run.ParentNo is not null && allByRunNo.TryGetValue(run.ParentNo, out var p) ? p : null;
        DOfv = OfvAnalysis.DeltaOfv(run, parent)
            ?.ToString("+0.000;-0.000;0.000", System.Globalization.CultureInfo.InvariantCulture)
            ?? string.Empty;

        ConditionNumber = lastEst?.ConditionNumber?.ToString("0", System.Globalization.CultureInfo.InvariantCulture) ?? string.Empty;
        ObsRecs = run.ObsRecs?.ToString() ?? string.Empty;
        Individuals = run.Individuals?.ToString() ?? string.Empty;
        Flag = run.Flag;
        WarningCount = run.Estimations.Sum(e => e.Warnings.Count);

        // Run-level timings (apply to the whole run). Show datetimes with a space, not 'T'.
        StartDateTime = run.StartDateTime?.Replace('T', ' ') ?? string.Empty;
        StopDateTime = run.StopDateTime?.Replace('T', ' ') ?? string.Empty;
        TotalCpuTime = run.TotalCpuTime?.ToString("0.##", System.Globalization.CultureInfo.InvariantCulture) ?? string.Empty;
    }

    public string RunNo { get; }
    public string ParentNo { get; }
    public string Comment { get; }
    public string Method { get; }
    public string Ofv { get; }
    public string DOfv { get; }
    public string ConditionNumber { get; }
    public string ObsRecs { get; }
    public string Individuals { get; }
    public int Flag { get; }
    public int WarningCount { get; }
    public string Warnings => WarningCount > 0 ? WarningCount.ToString() : string.Empty;
    public string StartDateTime { get; }
    public string StopDateTime { get; }
    public string TotalCpuTime { get; }

    // Flag colour palette, indexed by Flag (0 = unflagged).
    private static readonly IBrush[] FlagBrushes =
    [
        Brushes.Transparent,    // 0 = none
        Brushes.IndianRed,      // 1 = red
        Brushes.Orange,         // 2 = orange
        Brushes.Gold,           // 3 = yellow
        Brushes.MediumSeaGreen, // 4 = green
        Brushes.CornflowerBlue, // 5 = blue
    ];

    /// <summary>Flag circle colour in the run list, from the user-set flag (0-5).</summary>
    public IBrush FlagBrush => Flag >= 0 && Flag < FlagBrushes.Length ? FlagBrushes[Flag] : Brushes.Transparent;

    /// <summary>dOFV is shown in red when it is non-zero (matches the original Census UI).</summary>
    public IBrush DOfvBrush =>
        DOfv.StartsWith('+') || DOfv.StartsWith('-') ? Brushes.Firebrick : Brushes.Black;
}
