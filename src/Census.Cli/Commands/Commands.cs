using System.ComponentModel;
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
