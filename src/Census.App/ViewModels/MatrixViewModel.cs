using System.Globalization;
using Census.Domain;

namespace Census.App.ViewModels;

/// <summary>One matrix row: a label plus n formatted cell strings (blank above the diagonal).</summary>
public sealed class MatrixRowViewModel
{
    public MatrixRowViewModel(string label, IReadOnlyList<string> cells)
    {
        Label = label;
        Cells = cells;
    }

    public string Label { get; }
    public IReadOnlyList<string> Cells { get; }
}

/// <summary>Display model for a labelled lower-triangular matrix (covariance/correlation).</summary>
public sealed class MatrixViewModel
{
    public MatrixViewModel(NamedMatrix matrix)
    {
        ColumnHeaders = matrix.Labels.ToList();
        var n = matrix.Labels.Count;

        var rows = new List<MatrixRowViewModel>(n);
        for (var i = 0; i < n; i++)
        {
            var rowVals = i < matrix.Values.Count ? matrix.Values[i] : [];
            var cells = new List<string>(n);
            for (var j = 0; j < n; j++)
            {
                cells.Add(j < rowVals.Count ? Fmt(rowVals[j]) : string.Empty);
            }
            rows.Add(new MatrixRowViewModel(matrix.Labels[i], cells));
        }

        Rows = rows;
    }

    public IReadOnlyList<string> ColumnHeaders { get; }
    public IReadOnlyList<MatrixRowViewModel> Rows { get; }

    private static string Fmt(double? v) =>
        v.HasValue ? v.Value.ToString("G4", CultureInfo.InvariantCulture) : string.Empty;
}
