using Census.Domain;

namespace Census.Reports;

public enum ReportFormat
{
    Csv,
    Html,
    Latex,
}

/// <summary>
/// Generates a run report in a given format. CSV uses structured writing (CsvHelper);
/// HTML and LaTeX use templates (Scriban) with consistent escaping.
/// </summary>
public interface IReportWriter
{
    ReportFormat Format { get; }

    /// <summary>Render the run report to a string.</summary>
    string Render(Run run);
}
