using Census.Domain;
using System.Globalization;

namespace Census.App.ViewModels;

public sealed class RunDetailViewModel
{
    public RunDetailViewModel(Run run)
    {
        RunNo = run.RunNo;

        var lastEst = run.Estimations.Count > 0 ? run.Estimations[^1] : null;

        Method          = lastEst?.Method ?? string.Empty;
        Ofv             = lastEst?.Ofv?.ToString("0.000", CultureInfo.InvariantCulture) ?? string.Empty;
        ConditionNumber = lastEst?.ConditionNumber?.ToString("0", CultureInfo.InvariantCulture) ?? string.Empty;
        ObsRecs         = run.ObsRecs?.ToString() ?? string.Empty;
        Individuals     = run.Individuals?.ToString() ?? string.Empty;

        Warnings = lastEst?.Warnings ?? [];

        var parameters  = lastEst?.Parameters ?? [];
        Thetas  = parameters.Where(p => p.Kind == ParameterKind.Theta).Select(p => new ParameterRowViewModel(p)).ToList();
        Omegas  = parameters.Where(p => p.Kind == ParameterKind.Omega).Select(p => new ParameterRowViewModel(p)).ToList();
        Sigmas  = parameters.Where(p => p.Kind == ParameterKind.Sigma).Select(p => new ParameterRowViewModel(p)).ToList();

        AllParameters = parameters.Select(p => new ParameterRowViewModel(p)).ToList();

        EstimationCount = run.Estimations.Count;
        HasMultipleEstimations = run.Estimations.Count > 1;
    }

    public string RunNo             { get; }
    public string Method            { get; }
    public string Ofv               { get; }
    public string ConditionNumber   { get; }
    public string ObsRecs           { get; }
    public string Individuals       { get; }
    public IReadOnlyList<string>               Warnings      { get; }
    public IReadOnlyList<ParameterRowViewModel> Thetas        { get; }
    public IReadOnlyList<ParameterRowViewModel> Omegas        { get; }
    public IReadOnlyList<ParameterRowViewModel> Sigmas        { get; }
    public IReadOnlyList<ParameterRowViewModel> AllParameters { get; }
    public int  EstimationCount        { get; }
    public bool HasMultipleEstimations { get; }
    public bool HasWarnings            => Warnings.Count > 0;
    public bool HasThetas              => Thetas.Count > 0;
    public bool HasOmegas              => Omegas.Count > 0;
    public bool HasSigmas              => Sigmas.Count > 0;
}
