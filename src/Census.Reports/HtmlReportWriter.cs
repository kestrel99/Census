using System.Globalization;
using System.IO;
using System.Linq;
using Census.Domain;
using Scriban;
using Scriban.Runtime;

namespace Census.Reports;

/// <summary>
/// Renders a run report as an HTML document using a Scriban template.
/// </summary>
public sealed class HtmlReportWriter : IReportWriter
{
    public ReportFormat Format => ReportFormat.Html;

    private static readonly Template _template = LoadTemplate();

    private static Template LoadTemplate()
    {
        var asm = typeof(HtmlReportWriter).Assembly;
        using var stream = asm.GetManifestResourceStream(
            "Census.Reports.Templates.run_report.html")!;
        using var reader = new StreamReader(stream);
        return Template.Parse(reader.ReadToEnd());
    }

    private static ScriptObject BuildModel(Run run)
    {
        var obj = new ScriptObject();
        obj["run_no"] = run.RunNo;
        obj["obs_recs"] = run.ObsRecs;
        obj["individuals"] = run.Individuals;
        obj["estimations"] = run.Estimations.Select(e => new ScriptObject
        {
            ["number"] = e.Number,
            ["method"] = e.Method,
            ["ofv"] = e.Ofv.HasValue ? e.Ofv.Value.ToString("G6", CultureInfo.InvariantCulture) : "",
            ["condition_number"] = e.ConditionNumber.HasValue ? e.ConditionNumber.Value.ToString("G6", CultureInfo.InvariantCulture) : "",
            ["warnings"] = e.Warnings.ToList(),
            ["parameters"] = e.Parameters.Select(p =>
            {
                var row = ParameterRow.FromParameter(p);
                var ps = new ScriptObject();
                ps["kind"] = row.Kind;
                ps["index"] = row.Index;
                ps["label"] = row.Label ?? "";
                ps["estimate"] = FormatG4(row.Estimate);
                ps["se"] = FormatG4(row.StandardError);
                ps["rse"] = FormatG4(row.Rse);
                ps["ci_lower"] = FormatG4(row.CiLower);
                ps["ci_upper"] = FormatG4(row.CiUpper);
                ps["shrinkage"] = FormatG4(row.Shrinkage);
                return ps;
            }).ToList(),
        }).ToList();
        return obj;
    }

    private static string FormatG4(double? v) =>
        v.HasValue ? v.Value.ToString("G4", CultureInfo.InvariantCulture) : "";

    public string Render(Run run)
    {
        var ctx = new TemplateContext { StrictVariables = false };
        ctx.PushGlobal(BuildModel(run));
        return _template.Render(ctx);
    }
}
