using System.ComponentModel;
using Census.Storage;
using Spectre.Console;
using Spectre.Console.Cli;

namespace Census.Cli.Commands;

/// <summary>
/// Command stubs that define the headless CLI surface (IMPLEMENTATION_PLAN.md, phase 5).
/// Each will delegate to the shared Census.* services as those phases land.
/// </summary>
internal static class Stub
{
    public static int NotImplemented(string command)
    {
        AnsiConsole.MarkupLine($"[yellow]'{command}' is scaffolded but not yet implemented.[/]");
        return 0;
    }
}

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
                run.KeyRun ? "[green]✓[/]" : string.Empty);
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

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation) =>
        Stub.NotImplemented("import");
}

internal sealed class ImportFolderCommand : Command<ImportFolderCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<folder>")]
        public string Folder { get; init; } = string.Empty;

        [CommandArgument(1, "<project>")]
        public string Project { get; init; } = string.Empty;
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation) =>
        Stub.NotImplemented("import-folder");
}

internal sealed class ExportRunCommand : Command<ExportRunCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<runno>")]
        public string RunNo { get; init; } = string.Empty;

        [CommandOption("-f|--format <FORMAT>")]
        [Description("csv | html | latex")]
        [DefaultValue("html")]
        public string Format { get; init; } = "html";
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation) =>
        Stub.NotImplemented("export-run");
}

internal sealed class CompareCommand : Command<CompareCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<project>")]
        public string Project { get; init; } = string.Empty;
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation) =>
        Stub.NotImplemented("compare");
}

internal sealed class ArchiveCommand : Command<ArchiveCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<runno>")]
        public string RunNo { get; init; } = string.Empty;

        [CommandOption("--include-data")]
        public bool IncludeData { get; init; }
    }

    protected override int Execute(CommandContext context, Settings settings, CancellationToken cancellation) =>
        Stub.NotImplemented("archive");
}
