using System.ComponentModel;
using System.Text;
using Census.Archive;
using Census.Domain;
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
        [Description("NONMEM XML output file to import.")]
        public string Source { get; init; } = string.Empty;

        [CommandArgument(1, "<project>")]
        [Description("Target .cen project file.")]
        public string Project { get; init; } = string.Empty;

        [CommandOption("-y|--replace")]
        [Description("Replace an existing run with the same number (keeps comment, flag and parent).")]
        public bool Replace { get; init; }

        [CommandOption("--skip-existing")]
        [Description("Skip a run whose number already exists instead of prompting.")]
        public bool SkipExisting { get; init; }
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

            if (store.RunExists(run.IRunNo))
            {
                if (!ImportDuplicates.Resolve(run.RunNo, settings.Replace, settings.SkipExisting))
                {
                    AnsiConsole.MarkupLine($"[yellow]Skipped[/] existing run [bold]{run.RunNo}[/].");
                    return 0;
                }

                store.ReplaceRun(run);
                AnsiConsole.MarkupLine($"[green]Replaced[/] run [bold]{run.RunNo}[/] from {settings.Source}");
                return 0;
            }

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

/// <summary>Shared resolution of what to do when an imported run number already exists.</summary>
internal static class ImportDuplicates
{
    // Explicit flags win; otherwise prompt when the console is interactive; otherwise skip.
    // We never overwrite an existing run without explicit consent (a flag or a "yes" at the prompt).
    public static bool Resolve(string runNo, bool replace, bool skipExisting)
    {
        if (replace)
        {
            return true;
        }

        if (skipExisting)
        {
            return false;
        }

        if (AnsiConsole.Profile.Capabilities.Interactive)
        {
            return AnsiConsole.Confirm(
                $"Run [bold]{runNo}[/] already exists. Replace it (keeping comment, flag and parent)?",
                defaultValue: false);
        }

        AnsiConsole.MarkupLine(
            $"[yellow]Run {runNo} already exists; skipped.[/] Pass [bold]--replace[/] to overwrite.");
        return false;
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

        [CommandOption("-y|--replace")]
        [Description("Replace runs whose number already exists (keeps comment, flag and parent). Default: skip them.")]
        public bool Replace { get; init; }
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

        var scan = new FolderImporter(new NonmemXmlImporter()).ImportFolder(settings.Folder);

        var imported = 0;
        var replaced = 0;
        var skipped = 0;
        var failures = scan.Failures.ToList();

        AnsiConsole.Progress()
            .AutoClear(false)
            .Columns(new TaskDescriptionColumn(), new ProgressBarColumn(), new PercentageColumn(), new SpinnerColumn())
            .Start(ctx =>
            {
                var task = ctx.AddTask("[green]Saving[/]", maxValue: scan.Runs.Count);
                foreach (var run in scan.Runs)
                {
                    try
                    {
                        if (store.RunExists(run.IRunNo))
                        {
                            // Batch import does not prompt per file; --replace overwrites, default skips.
                            if (settings.Replace)
                            {
                                store.ReplaceRun(run);
                                replaced++;
                            }
                            else
                            {
                                skipped++;
                            }
                        }
                        else
                        {
                            store.SaveRun(run);
                            imported++;
                        }
                    }
                    catch (Exception ex)
                    {
                        var source = run.Files.FirstOrDefault()?.Path ?? $"run {run.RunNo}";
                        failures.Add(new ImportFailure(source, ex.Message));
                    }

                    task.Increment(1);
                }
            });

        var summary = new Table().Border(TableBorder.Rounded);
        summary.AddColumn("Result");
        summary.AddColumn("Count");
        summary.AddRow("[green]Imported[/]", imported.ToString());
        summary.AddRow("[blue]Replaced[/]", replaced.ToString());
        summary.AddRow("[grey]Skipped[/]", skipped.ToString());
        summary.AddRow("[red]Failed[/]", failures.Count.ToString());
        AnsiConsole.Write(summary);

        if (failures.Count > 0)
        {
            var table = new Table().Border(TableBorder.Rounded).Title("[red]Failed imports[/]");
            table.AddColumn("File");
            table.AddColumn("Error");
            foreach (var f in failures)
            {
                table.AddRow(Markup.Escape(Path.GetFileName(f.Path)), Markup.Escape(f.Error));
            }

            AnsiConsole.Write(table);
        }

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

            var parent = run.ParentNo is not null && lookup.TryGetValue(run.ParentNo, out var p) ? p : null;
            var dofv = OfvAnalysis.DeltaOfv(run, parent);

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
