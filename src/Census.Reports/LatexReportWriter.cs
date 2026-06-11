using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using Census.Domain;
using Scriban;
using Scriban.Runtime;

namespace Census.Reports;

/// <summary>
/// Renders a run report as a LaTeX document using a Scriban template.
/// </summary>
public sealed class LatexReportWriter : IReportWriter
{
    public ReportFormat Format => ReportFormat.Latex;

    private static readonly Template _template = LoadTemplate();

    private static Template LoadTemplate()
    {
        var asm = typeof(LatexReportWriter).Assembly;
        using var stream = asm.GetManifestResourceStream(
            "Census.Reports.Templates.run_report.tex")!;
        using var reader = new StreamReader(stream);
        return Template.Parse(reader.ReadToEnd());
    }

    /// <summary>
    /// Escapes a string for safe use inside a LaTeX document.
    /// Returns an empty string when <paramref name="s"/> is null.
    /// </summary>
    internal static string LatexEscape(string? s)
    {
        if (s is null) return "";

        // Process in order: backslash first so the replacements we add next
        // don't themselves get escaped.
        var sb = new StringBuilder(s);
        sb.Replace("\\", "\\textbackslash{}");
        sb.Replace("{", "\\{");
        sb.Replace("}", "\\}");
        sb.Replace("$", "\\$");
        sb.Replace("&", "\\&");
        sb.Replace("#", "\\#");
        sb.Replace("^", "\\textasciicircum{}");
        sb.Replace("_", "\\_");
        sb.Replace("~", "\\textasciitilde{}");
        sb.Replace("%", "\\%");
        return sb.ToString();
    }

    private static ScriptObject BuildModel(Run run)
    {
        var obj = new ScriptObject();
        obj["run_no"] = LatexEscape(run.RunNo);
        obj["obs_recs"] = run.ObsRecs;
        obj["individuals"] = run.Individuals;
        obj["estimations"] = run.Estimations.Select(e => new ScriptObject
        {
            ["number"] = e.Number,
            ["method"] = LatexEscape(e.Method),
            ["ofv"] = e.Ofv.HasValue ? e.Ofv.Value.ToString("G6", CultureInfo.InvariantCulture) : "",
            ["condition_number"] = e.ConditionNumber.HasValue ? e.ConditionNumber.Value.ToString("G6", CultureInfo.InvariantCulture) : "",
            ["warnings"] = e.Warnings.Select(w => LatexEscape(w)).ToList(),
            ["parameters"] = e.Parameters.Select(p =>
            {
                var row = ParameterRow.FromParameter(p);
                var ps = new ScriptObject();
                ps["kind"] = row.Kind;
                ps["index"] = row.Index;
                ps["label"] = LatexEscape(row.Label);
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
