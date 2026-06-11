using System.Globalization;
using Census.Domain;

namespace Census.App.ViewModels;

/// <summary>
/// One estimation step shown in the bottom-left "Estimation" grid. Selecting a step
/// drives the parameter tabs (theta/omega/sigma) on the right.
/// </summary>
public sealed class EstimationStepViewModel
{
    public EstimationStepViewModel(Estimation est)
    {
        Step = est.Number;
        Title = est.Method ?? string.Empty;
        Status = est.Warnings.Count > 0 ? "Terminated" : "Successful";
        Ofv = est.Ofv?.ToString("0.000", CultureInfo.InvariantCulture) ?? string.Empty;
        ConditionNumber = est.ConditionNumber?.ToString("0.###", CultureInfo.InvariantCulture) ?? string.Empty;

        var ps = est.Parameters;
        Thetas = ps.Where(p => p.Kind == ParameterKind.Theta).Select(p => new ParameterRowViewModel(p)).ToList();
        Omegas = ps.Where(p => p.Kind == ParameterKind.Omega).Select(p => new ParameterRowViewModel(p)).ToList();
        Sigmas = ps.Where(p => p.Kind == ParameterKind.Sigma).Select(p => new ParameterRowViewModel(p)).ToList();
        Warnings = est.Warnings;
    }

    public int Step { get; }
    public string Title { get; }
    public string Status { get; }
    public string Ofv { get; }
    public string ConditionNumber { get; }
    public IReadOnlyList<ParameterRowViewModel> Thetas { get; }
    public IReadOnlyList<ParameterRowViewModel> Omegas { get; }
    public IReadOnlyList<ParameterRowViewModel> Sigmas { get; }
    public IReadOnlyList<string> Warnings { get; }

    public override string ToString() => $"{Step}: {Title}";
}
