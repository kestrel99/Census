using System.ComponentModel;
using System.Text;
using Census.Archive;
using Census.Import;
using Census.Reports;
using Census.Storage;
using Spectre.Console;
using Spectre.Console.Cli;

namespace Census.Cli.Commands;

internal sealed class NewCommand : Command<NewCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<project>")]
        [Description("Path to the .cen project file to create.")]
        public string Project { get; init; } = string.Empty;
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation)
    {
        new SqliteProjectStore().Create(settings.Project);
        AnsiConsole.MarkupLine($"[green]Created[/] {settings.Project}");
        return 0;
    }
}

internal sealed class ListCommand : Command<ListCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<project>")]
        [Description("Path to the .cen project file.")]
        public string Project { get; init; } = string.Empty;
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation)
    {
        var store = new SqliteProjectStore();
        store.Open(settings.Project);
        var runs = store.GetRuns();

        if (runs.Count == 0)
        {
            AnsiConsole.MarkupLine("[grey]No runs in project.[/]");
            return 0;
        }

        var table = new Table().Border(TableBorder.Rounded);
        table.AddColumn("Run");
        table.AddColumn("Parent");
        table.AddColumn("Method");
        table.AddColumn("OFV");
        table.AddColumn("Key");

        foreach (var run in runs)
        {
            var first = run.Estimations.Count > 0 ? run.Estimations[^1] : null;
            table.AddRow(
                run.RunNo,
                run.ParentNo ?? string.Empty,
                first?.Method ?? string.Empty,
                first?.Ofv?.ToString("0.000", System.Globalization.CultureInfo.InvariantCulture) ?? string.Empty,
                run.Flag != 0 ? "[green]✓[/]" : string.Empty);
        }

        AnsiConsole.Write(table);
        return 0;
    }
}

internal sealed class ImportCommand : Command<ImportCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<source>")]
        [Description("NONMEM XML/listing file to import.")]
        public string Source { get; init; } = string.Empty;

        [CommandArgument(1, "<project>")]
        [Description("Target .cen project file.")]
        public string Project { get; init; } = string.Empty;
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation)
    {
        if (!File.Exists(settings.Source))
        {
            AnsiConsole.MarkupLine($"[red]Source file not found: {settings.Source}[/]");
            return 1;
        }

        var importer = new NonmemXmlImporter();
        if (!importer.CanImport(settings.Source))
        {
            AnsiConsole.MarkupLine($"[red]Cannot import file (unrecognised format): {settings.Source}[/]");
            return 1;
        }

        try
        {
            var store = new SqliteProjectStore();
            if (File.Exists(settings.Project))
                store.Open(settings.Project);
            else
                store.Create(settings.Project);

            var run = importer.Import(settings.Source);
            store.SaveRun(run);
            AnsiConsole.MarkupLine($"[green]Imported[/] run [bold]{run.RunNo}[/] from {settings.Source}");
            return 0;
        }
        catch (Exception ex)
        {
            AnsiConsole.MarkupLine($"[red]Import failed: {ex.Message}[/]");
            return 1;
        }
    }
}

internal sealed class ImportFolderCommand : Command<ImportFolderCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<folder>")]
        [Description("Directory to scan for NONMEM XML files.")]
        public string Folder { get; init; } = string.Empty;

        [CommandArgument(1, "<project>")]
        [Description("Target .cen project file.")]
        public string Project { get; init; } = string.Empty;
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation)
    {
        if (!Directory.Exists(settings.Folder))
        {
            AnsiConsole.MarkupLine($"[red]Folder not found: {settings.Folder}[/]");
            return 1;
        }

        var store = new SqliteProjectStore();
        if (File.Exists(settings.Project))
            store.Open(settings.Project);
        else
            store.Create(settings.Project);

        var files = Directory.GetFiles(settings.Folder, "*.xml", SearchOption.AllDirectories);

        var imported = 0;
        var skipped = 0;
        var failed = 0;

        AnsiConsole.Progress()
            .AutoClear(false)
            .Columns(new TaskDescriptionColumn(), new ProgressBarColumn(), new PercentageColumn(), new SpinnerColumn())
            .Start(ctx =>
            {
                var task = ctx.AddTask("[green]Importing[/]", maxValue: files.Length);
                foreach (var file in files)
                {
                    var imp = new NonmemXmlImporter();
                    if (!imp.CanImport(file))
                    {
                        skipped++;
                        task.Increment(1);
                        continue;
                    }

                    try
                    {
                        var run = imp.Import(file);
                        store.SaveRun(run);
                        imported++;
                    }
                    catch
                    {
                        failed++;
                    }

                    task.Increment(1);
                }
            });

        var summary = new Table().Border(TableBorder.Rounded);
        summary.AddColumn("Result");
        summary.AddColumn("Count");
        summary.AddRow("[green]Imported[/]", imported.ToString());
        summary.AddRow("[grey]Skipped[/]", skipped.ToString());
        summary.AddRow("[red]Failed[/]", failed.ToString());
        AnsiConsole.Write(summary);

        return 0;
    }
}

internal sealed class ExportRunCommand : Command<ExportRunCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<project>")]
        [Description("Path to the .cen project file.")]
        public string Project { get; init; } = string.Empty;

        [CommandArgument(1, "<runno>")]
        [Description("Run number to export.")]
        public string RunNo { get; init; } = string.Empty;

        [CommandOption("-f|--format <FORMAT>")]
        [Description("Output format: csv, html, latex. Default: html.")]
        [DefaultValue("html")]
        public string Format { get; init; } = "html";

        [CommandOption("-o|--output <FILE>")]
        [Description("Output file path. Writes to stdout if omitted.")]
        public string? Output { get; init; }
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation)
    {
        var store = new SqliteProjectStore();
        store.Open(settings.Project);
        var runs = store.GetRuns();

        var run = runs.FirstOrDefault(r =>
            string.Equals(r.RunNo, settings.RunNo, StringComparison.OrdinalIgnoreCase));

        if (run is null)
        {
            AnsiConsole.MarkupLine($"[red]Run not found: {settings.RunNo}[/]");
            return 1;
        }

        IReportWriter writer = settings.Format.ToLowerInvariant() switch
        {
            "csv" => new CsvReportWriter(),
            "latex" => new LatexReportWriter(),
            _ => new HtmlReportWriter(),
        };

        var content = writer.Render(run);

        if (settings.Output is not null)
        {
            File.WriteAllText(settings.Output, content, Encoding.UTF8);
            AnsiConsole.MarkupLine($"[green]Exported[/] to {settings.Output}");
        }
        else
        {
            Console.Write(content);
        }

        return 0;
    }
}

internal sealed class CompareCommand : Command<CompareCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<project>")]
        [Description("Path to the .cen project file.")]
        public string Project { get; init; } = string.Empty;
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation)
    {
        var store = new SqliteProjectStore();
        store.Open(settings.Project);
        var runs = store.GetRuns();

        var lookup = runs.ToDictionary(r => r.RunNo, StringComparer.OrdinalIgnoreCase);

        var table = new Table().Border(TableBorder.Rounded);
        table.AddColumn("Run");
        table.AddColumn("Parent");
        table.AddColumn("Method");
        table.AddColumn("OFV");
        table.AddColumn("dOFV");
        table.AddColumn("Cond#");
        table.AddColumn("Obs");
        table.AddColumn("Ind");
        table.AddColumn("Warnings");

        foreach (var run in runs.OrderBy(r => r.IRunNo))
        {
            var lastEst = run.Estimations.Count > 0 ? run.Estimations[^1] : null;

            double? dofv = null;
            if (run.ParentNo is not null
                && lookup.TryGetValue(run.ParentNo, out var parent)
                && run.Estimations.Count > 0
                && parent.Estimations.Count > 0)
            {
                dofv = run.Estimations[^1].Ofv - parent.Estimations[^1].Ofv;
            }

            var dofvStr = dofv switch
            {
                null => "",
                > 0 => $"[red]+{dofv:0.3}[/]",
                < 0 => $"[green]{dofv:0.3}[/]",
                _ => "0.000",
            };

            var warningCount = run.Estimations.Sum(e => e.Warnings.Count);
            var warningsStr = warningCount > 0 ? warningCount.ToString() : "";

            table.AddRow(
                run.RunNo,
                run.ParentNo ?? "",
                lastEst?.Method ?? "",
                lastEst?.Ofv?.ToString("0.3", System.Globalization.CultureInfo.InvariantCulture) ?? "",
                dofvStr,
                lastEst?.ConditionNumber?.ToString("0", System.Globalization.CultureInfo.InvariantCulture) ?? "",
                run.ObsRecs?.ToString() ?? "",
                run.Individuals?.ToString() ?? "",
                warningsStr);
        }

        AnsiConsole.Write(table);
        return 0;
    }
}

internal sealed class ArchiveCommand : Command<ArchiveCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<project>")]
        [Description("Path to the .cen project file.")]
        public string Project { get; init; } = string.Empty;

        [CommandArgument(1, "<runno>")]
        [Description("Run number to archive.")]
        public string RunNo { get; init; } = string.Empty;

        [CommandArgument(2, "<destination>")]
        [Description("Destination ZIP file path.")]
        public string Destination { get; init; } = string.Empty;

        [CommandOption("--include-data")]
        [Description("Include data-role artifacts in the archive.")]
        public bool IncludeData { get; init; }
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation)
    {
        var store = new SqliteProjectStore();
        store.Open(settings.Project);
        var runs = store.GetRuns();

        var run = runs.FirstOrDefault(r =>
            string.Equals(r.RunNo, settings.RunNo, StringComparison.OrdinalIgnoreCase));

        if (run is null)
        {
            AnsiConsole.MarkupLine($"[red]Run not found: {settings.RunNo}[/]");
            return 1;
        }

        new RunArchiver().Archive(run, settings.Destination, settings.IncludeData);
        AnsiConsole.MarkupLine($"[green]Archived[/] run {run.RunNo} to {settings.Destination}");
        return 0;
    }
}
