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
        Method = lastEst?.Method ?? string.Empty;
        Ofv = lastEst?.Ofv?.ToString("0.000", System.Globalization.CultureInfo.InvariantCulture) ?? string.Empty;

        // Compute dOFV relative to parent
        if (run.ParentNo is not null
            && allByRunNo.TryGetValue(run.ParentNo, out var parent)
            && lastEst?.Ofv.HasValue == true
            && parent.Estimations.Count > 0
            && parent.Estimations[^1].Ofv.HasValue)
        {
            var delta = lastEst.Ofv!.Value - parent.Estimations[^1].Ofv!.Value;
            DOfv = delta.ToString("+0.000;-0.000;0.000", System.Globalization.CultureInfo.InvariantCulture);
        }
        else
        {
            DOfv = string.Empty;
        }

        ConditionNumber = lastEst?.ConditionNumber?.ToString("0", System.Globalization.CultureInfo.InvariantCulture) ?? string.Empty;
        ObsRecs = run.ObsRecs?.ToString() ?? string.Empty;
        Individuals = run.Individuals?.ToString() ?? string.Empty;
        KeyRun = run.KeyRun;
        WarningCount = run.Estimations.Sum(e => e.Warnings.Count);
    }

    public string RunNo { get; }
    public string ParentNo { get; }
    public string Method { get; }
    public string Ofv { get; }
    public string DOfv { get; }
    public string ConditionNumber { get; }
    public string ObsRecs { get; }
    public string Individuals { get; }
    public bool KeyRun { get; }
    public int WarningCount { get; }
    public string Warnings => WarningCount > 0 ? WarningCount.ToString() : string.Empty;
}
