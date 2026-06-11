using Census.Domain;
using Census.Reports;
using System.Globalization;

namespace Census.App.ViewModels;

public sealed class ParameterRowViewModel
{
    public ParameterRowViewModel(Parameter p)
    {
        var row = ParameterRow.FromParameter(p);
        Kind      = row.Kind;
        Index     = p.Index;
        Label     = p.Label ?? string.Empty;
        Estimate  = Fmt(row.Estimate);
        Se        = Fmt(row.StandardError);
        Rse       = Fmt(row.Rse);
        CiLower   = Fmt(row.CiLower);
        CiUpper   = Fmt(row.CiUpper);
        Shrinkage = Fmt(row.Shrinkage);
    }

    private static string Fmt(double? v) =>
        v.HasValue ? v.Value.ToString("G4", CultureInfo.InvariantCulture) : string.Empty;

    public string Kind      { get; }
    public int    Index     { get; }
    public string Label     { get; }
    public string Estimate  { get; }
    public string Se        { get; }
    public string Rse       { get; }
    public string CiLower   { get; }
    public string CiUpper   { get; }
    public string Shrinkage { get; }

    /// <summary>Formatted 95% CI as "lower – upper" or empty.</summary>
    public string Ci => (CiLower.Length > 0 && CiUpper.Length > 0)
        ? $"{CiLower} – {CiUpper}"
        : string.Empty;
}
