using System.Globalization;
using Census.Domain;

namespace Census.App.ViewModels;

/// <summary>
/// A row in the bottom-left "Estimation" grid. Most rows are estimation steps (selecting
/// one drives the parameter tabs). The grid also carries run-level timing rows
/// (start/stop time, total CPU time, post-processing times) appended after the steps.
/// </summary>
public sealed class EstimationStepViewModel
{
    /// <summary>Estimation-step row.</summary>
    public EstimationStepViewModel(Estimation est)
    {
        IsEstimation = true;
        Step = est.Number.ToString(CultureInfo.InvariantCulture);
        Title = est.Method ?? string.Empty;
        Status = est.Warnings.Count > 0 ? "Terminated" : "Successful";
        EstTime = FmtSeconds(est.EstimationTime);
        CovTime = FmtSeconds(est.CovarianceTime);
        Ofv = est.Ofv?.ToString("0.000", CultureInfo.InvariantCulture) ?? string.Empty;
        ConditionNumber = est.ConditionNumber?.ToString("0.###", CultureInfo.InvariantCulture) ?? string.Empty;

        var ps = est.Parameters;
        Thetas = ps.Where(p => p.Kind == ParameterKind.Theta).Select(p => new ParameterRowViewModel(p)).ToList();
        Omegas = ps.Where(p => p.Kind == ParameterKind.Omega).Select(p => new ParameterRowViewModel(p)).ToList();
        Sigmas = ps.Where(p => p.Kind == ParameterKind.Sigma).Select(p => new ParameterRowViewModel(p)).ToList();
        Warnings = est.Warnings;
    }

    /// <summary>Run-level timing row (no parameters); the value is shown in the Est Time column.</summary>
    public EstimationStepViewModel(string title, string value)
    {
        IsEstimation = false;
        Step = string.Empty;
        Title = title;
        Status = string.Empty;
        EstTime = value;
        CovTime = string.Empty;
        Ofv = string.Empty;
        ConditionNumber = string.Empty;
        Thetas = [];
        Omegas = [];
        Sigmas = [];
        Warnings = [];
    }

    public bool IsEstimation { get; }
    public string Step { get; }
    public string Title { get; }
    public string Status { get; }
    public string EstTime { get; }
    public string CovTime { get; }
    public string Ofv { get; }
    public string ConditionNumber { get; }
    public IReadOnlyList<ParameterRowViewModel> Thetas { get; }
    public IReadOnlyList<ParameterRowViewModel> Omegas { get; }
    public IReadOnlyList<ParameterRowViewModel> Sigmas { get; }
    public IReadOnlyList<string> Warnings { get; }

    private static string FmtSeconds(double? v) =>
        v.HasValue ? v.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;

    public override string ToString() => IsEstimation ? $"{Step}: {Title}" : Title;
}
