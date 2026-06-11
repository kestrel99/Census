using System.Globalization;
using System.IO;
using Census.Domain;
using CsvHelper;
using CsvHelper.Configuration;

namespace Census.Reports;

/// <summary>
/// Renders a run report as CSV using CsvHelper.
/// Columns: RunNo, EstNo, Method, OFV, Kind, Index, Label, Estimate, SE, RSE_Pct,
///          CI_Lower, CI_Upper, Shrinkage_Pct
/// </summary>
public sealed class CsvReportWriter : IReportWriter
{
    public ReportFormat Format => ReportFormat.Csv;

    public string Render(Run run)
    {
        var config = new CsvConfiguration(CultureInfo.InvariantCulture)
        {
            HasHeaderRecord = true,
            NewLine = "\n",
        };

        using var sw = new StringWriter();
        using var csv = new CsvWriter(sw, config);

        // Header
        csv.WriteField("RunNo");
        csv.WriteField("EstNo");
        csv.WriteField("Method");
        csv.WriteField("OFV");
        csv.WriteField("Kind");
        csv.WriteField("Index");
        csv.WriteField("Label");
        csv.WriteField("Estimate");
        csv.WriteField("SE");
        csv.WriteField("RSE_Pct");
        csv.WriteField("CI_Lower");
        csv.WriteField("CI_Upper");
        csv.WriteField("Shrinkage_Pct");
        csv.NextRecord();

        foreach (var est in run.Estimations)
        {
            foreach (var param in est.Parameters)
            {
                var row = ParameterRow.FromParameter(param);

                csv.WriteField(run.RunNo);
                csv.WriteField(est.Number.ToString(CultureInfo.InvariantCulture));
                csv.WriteField(est.Method ?? string.Empty);
                csv.WriteField(FormatDouble(est.Ofv));
                csv.WriteField(row.Kind);
                csv.WriteField(row.Index.ToString(CultureInfo.InvariantCulture));
                csv.WriteField(row.Label ?? string.Empty);
                csv.WriteField(FormatDouble(row.Estimate));
                csv.WriteField(FormatDouble(row.StandardError));
                csv.WriteField(FormatDouble(row.Rse));
                csv.WriteField(FormatDouble(row.CiLower));
                csv.WriteField(FormatDouble(row.CiUpper));
                csv.WriteField(FormatDouble(row.Shrinkage));
                csv.NextRecord();
            }
        }

        csv.Flush();
        return sw.ToString();
    }

    private static string FormatDouble(double? value) =>
        value.HasValue ? value.Value.ToString("G6", CultureInfo.InvariantCulture) : string.Empty;
}
