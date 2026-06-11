using System.Globalization;
using Census.Domain;

namespace Census.Reports;

/// <summary>
/// Computed view model for one parameter row in a report.
/// </summary>
public readonly record struct ParameterRow
{
    public string Kind { get; init; }
    public int Index { get; init; }
    public string? Label { get; init; }
    public double? Estimate { get; init; }
    public double? StandardError { get; init; }
    public double? Rse { get; init; }
    public double? CiLower { get; init; }
    public double? CiUpper { get; init; }
    public double? Shrinkage { get; init; }

    public static ParameterRow FromParameter(Parameter p)
    {
        string kind = p.Kind switch
        {
            ParameterKind.Theta => "THETA",
            ParameterKind.Omega => "OMEGA",
            ParameterKind.Sigma => "SIGMA",
            _ => p.Kind.ToString().ToUpperInvariant(),
        };

        double? rse = (p.StandardError.HasValue && p.Estimate.HasValue && p.Estimate.Value != 0.0)
            ? (p.StandardError.Value / Math.Abs(p.Estimate.Value)) * 100.0
            : null;

        double? ciLower = (p.Estimate.HasValue && p.StandardError.HasValue)
            ? p.Estimate.Value - 1.96 * p.StandardError.Value
            : null;

        double? ciUpper = (p.Estimate.HasValue && p.StandardError.HasValue)
            ? p.Estimate.Value + 1.96 * p.StandardError.Value
            : null;

        return new ParameterRow
        {
            Kind = kind,
            Index = p.Index,
            Label = p.Label,
            Estimate = p.Estimate,
            StandardError = p.StandardError,
            Rse = rse,
            CiLower = ciLower,
            CiUpper = ciUpper,
            Shrinkage = p.Shrinkage,
        };
    }
}
