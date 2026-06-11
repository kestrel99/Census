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

        Estimations = new ObservableCollection<EstimationStepViewModel>(
            run.Estimations.Select(e => new EstimationStepViewModel(e)));

        // Default to the final estimation step, as the original UI does.
        SelectedEstimation = Estimations.Count > 0 ? Estimations[^1] : null;
    }

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
