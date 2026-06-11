using Census.Cli.Commands;
using Spectre.Console.Cli;

var app = new CommandApp();
app.Configure(config =>
{
    config.SetApplicationName("census");
    config.AddCommand<NewCommand>("new")
        .WithDescription("Create a new empty project file.");
    config.AddCommand<ListCommand>("list")
        .WithDescription("List the runs in a project.");
    config.AddCommand<ImportCommand>("import")
        .WithDescription("Import a NONMEM run (XML or listing) into a project.");
    config.AddCommand<ImportFolderCommand>("import-folder")
        .WithDescription("Discover and import all runs under a folder.");
    config.AddCommand<ExportRunCommand>("export-run")
        .WithDescription("Export a run report (default: html; also csv, latex).");
    config.AddCommand<CompareCommand>("compare")
        .WithDescription("Compare runs in a project.");
    config.AddCommand<ArchiveCommand>("archive")
        .WithDescription("Archive a run and its artifacts to a ZIP.");
});

return app.Run(args);
