using System.Globalization;
using Census.Domain;

namespace Census.App.ViewModels;

/// <summary>One comparison row: a label plus one cell value per run (column order).</summary>
public sealed class CompareRowViewModel
{
    public CompareRowViewModel(string label, IReadOnlyList<string> values)
    {
        Label = label;
        Values = values;
    }

    public string Label { get; }
    public IReadOnlyList<string> Values { get; }
}

/// <summary>
/// Side-by-side comparison of runs: OFV, dOFV and condition number, followed by every
/// parameter (theta/omega/sigma) found across the runs. Columns are the runs (ordered by
/// run number); the parameter columns are generated in the view from <see cref="RunHeaders"/>.
/// </summary>
public sealed class CompareViewModel
{
    public CompareViewModel(IReadOnlyList<Run> runs)
    {
        // Preserve selection order: the first selected run is the first column and the
        // reference against which every other run's dOFV is computed.
        var ordered = runs.ToList();
        RunHeaders = ordered.Select(r => r.RunNo).ToList();

        static Estimation? Last(Run r) => r.Estimations.Count > 0 ? r.Estimations[^1] : null;

        var referenceOfv = ordered.Count > 0 ? Last(ordered[0])?.Ofv : null;

        var rows = new List<CompareRowViewModel>
        {
            new("OFV", ordered.Select(r =>
                Last(r)?.Ofv?.ToString("0.000", CultureInfo.InvariantCulture) ?? string.Empty).ToList()),

            new("dOFV (vs first)", ordered.Select(r =>
            {
                var ofv = Last(r)?.Ofv;
                if (ofv is null || referenceOfv is null)
                    return string.Empty;
                return (ofv.Value - referenceOfv.Value).ToString("+0.000;-0.000;0.000", CultureInfo.InvariantCulture);
            }).ToList()),

            new("Condition no.", ordered.Select(r =>
                Last(r)?.ConditionNumber?.ToString("0", CultureInfo.InvariantCulture) ?? string.Empty).ToList()),
        };

        // Union of parameters across all runs, ordered theta -> omega -> sigma by index.
        var keys = ordered
            .SelectMany(r => Last(r)?.Parameters ?? Enumerable.Empty<Parameter>())
            .Select(p => (p.Kind, p.Index))
            .Distinct()
            .OrderBy(k => k.Kind)
            .ThenBy(k => k.Index)
            .ToList();

        foreach (var (kind, index) in keys)
        {
            var label = ordered
                .Select(r => Last(r)?.Parameters.FirstOrDefault(p => p.Kind == kind && p.Index == index)?.Label)
                .FirstOrDefault(l => !string.IsNullOrEmpty(l));

            var name = $"{kind.ToString().ToUpperInvariant()}{index}"
                + (string.IsNullOrEmpty(label) ? string.Empty : $" ({label})");

            var values = ordered.Select(r =>
            {
                var p = Last(r)?.Parameters.FirstOrDefault(pp => pp.Kind == kind && pp.Index == index);
                return p?.Estimate?.ToString("G4", CultureInfo.InvariantCulture) ?? string.Empty;
            }).ToList();

            rows.Add(new CompareRowViewModel(name, values));
        }

        Rows = rows;
    }

    public IReadOnlyList<string> RunHeaders { get; }
    public IReadOnlyList<CompareRowViewModel> Rows { get; }
}
