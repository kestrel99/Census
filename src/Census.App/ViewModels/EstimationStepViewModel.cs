using System.Globalization;
using Census.Domain;

namespace Census.App.ViewModels;

/// <summary>
/// One estimation ($EST) step shown in the bottom-left "Estimation" grid. Selecting a
/// step drives the parameter tabs (theta/omega/sigma) on the right. Post-process and
/// final-output times are per-problem values, shown on every step row of the run.
/// </summary>
public sealed class EstimationStepViewModel
{
    public EstimationStepViewModel(Estimation est, string postTime, string finalOutTime)
    {
        Step = est.Number.ToString(CultureInfo.InvariantCulture);
        Title = est.Method ?? string.Empty;
        Status = est.Warnings.Count > 0 ? "Terminated" : "Successful";
        EstTime = FmtSeconds(est.EstimationTime);
        CovTime = FmtSeconds(est.CovarianceTime);
        PostTime = postTime;
        FinalOutTime = finalOutTime;
        Ofv = est.Ofv?.ToString("0.000", CultureInfo.InvariantCulture) ?? string.Empty;
        ConditionNumber = est.ConditionNumber?.ToString("0.###", CultureInfo.InvariantCulture) ?? string.Empty;

        var ps = est.Parameters;
        Thetas = ps.Where(p => p.Kind == ParameterKind.Theta).Select(p => new ParameterRowViewModel(p)).ToList();
        Omegas = ps.Where(p => p.Kind == ParameterKind.Omega).Select(p => new ParameterRowViewModel(p)).ToList();
        Sigmas = ps.Where(p => p.Kind == ParameterKind.Sigma).Select(p => new ParameterRowViewModel(p)).ToList();
        Warnings = est.Warnings;

        Correlation = est.Correlation is not null ? new MatrixViewModel(est.Correlation) : null;
        Covariance = est.Covariance is not null ? new MatrixViewModel(est.Covariance) : null;
    }

    public string Step { get; }
    public string Title { get; }
    public string Status { get; }
    public string EstTime { get; }
    public string CovTime { get; }
    public string PostTime { get; }
    public string FinalOutTime { get; }
    public string Ofv { get; }
    public string ConditionNumber { get; }
    public IReadOnlyList<ParameterRowViewModel> Thetas { get; }
    public IReadOnlyList<ParameterRowViewModel> Omegas { get; }
    public IReadOnlyList<ParameterRowViewModel> Sigmas { get; }
    public IReadOnlyList<string> Warnings { get; }
    public MatrixViewModel? Correlation { get; }
    public MatrixViewModel? Covariance { get; }

    internal static string FmtSeconds(double? v) =>
        v.HasValue ? v.Value.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty;

    public override string ToString() => $"{Step}: {Title}";
}
