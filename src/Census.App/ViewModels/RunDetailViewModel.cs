using System.Collections.ObjectModel;
using System.Globalization;
using Census.Domain;
using CommunityToolkit.Mvvm.ComponentModel;

namespace Census.App.ViewModels;

/// <summary>
/// Drives the bottom region of the main window: the "Estimation" steps grid on the
/// left and the parameter tabs (theta/omega/sigma/…) on the right, which follow the
/// currently selected estimation step.
/// </summary>
public sealed partial class RunDetailViewModel : ObservableObject
{
    public RunDetailViewModel(Run run)
    {
        RunNo = run.RunNo;
        ParentNo = run.ParentNo ?? string.Empty;
        Comment = run.Comment ?? string.Empty;
        ObsRecs = run.ObsRecs?.ToString(CultureInfo.InvariantCulture) ?? string.Empty;
        Individuals = run.Individuals?.ToString(CultureInfo.InvariantCulture) ?? string.Empty;
        FileCount = run.Files.Count.ToString(CultureInfo.InvariantCulture);

        var rows = run.Estimations.Select(e => new EstimationStepViewModel(e)).ToList();

        // Run-level timing values appear as extra rows after the estimation steps.
        AddTimingRow(rows, "Start time", run.StartDateTime);
        AddTimingRow(rows, "Stop time", run.StopDateTime);
        AddTimingRow(rows, "Total CPU time", FmtSeconds(run.TotalCpuTime));
        AddTimingRow(rows, "Post-process time", FmtSeconds(run.PostElapsedTime));
        AddTimingRow(rows, "Final output time", FmtSeconds(run.FinalOutputElapsedTime));

        Estimations = new ObservableCollection<EstimationStepViewModel>(rows);

        // Default to the final estimation step (not a timing row), as the original UI does.
        SelectedEstimation = Estimations.LastOrDefault(r => r.IsEstimation) ?? Estimations.FirstOrDefault();
    }

    private static void AddTimingRow(List<EstimationStepViewModel> rows, string label, string? value)
    {
        if (!string.IsNullOrEmpty(value))
            rows.Add(new EstimationStepViewModel(label, value));
    }

    private static string? FmtSeconds(double? v) =>
        v.HasValue ? v.Value.ToString("0.##", CultureInfo.InvariantCulture) : null;

    public string RunNo { get; }
    public string ParentNo { get; }
    public string Comment { get; }
    public string ObsRecs { get; }
    public string Individuals { get; }
    public string FileCount { get; }

    public ObservableCollection<EstimationStepViewModel> Estimations { get; }

    [ObservableProperty]
    private EstimationStepViewModel? _selectedEstimation;
}
