using Census.Domain;

namespace Census.Import;

/// <summary>One file that could not be imported, with the reason why.</summary>
public sealed record ImportFailure(string Path, string Error);

/// <summary>
/// The outcome of scanning a folder: every run that parsed, and every file that failed to parse.
/// Persistence and duplicate-resolution are the caller's responsibility — this is pure and testable.
/// </summary>
public sealed record FolderImportResult(IReadOnlyList<Run> Runs, IReadOnlyList<ImportFailure> Failures);

/// <summary>
/// Imports every importable file under a folder, recording per-file failures instead of silently
/// swallowing them, so the CLI/UI can show which files failed and why.
/// </summary>
public sealed class FolderImporter
{
    private readonly IRunImporter _importer;

    public FolderImporter(IRunImporter importer) => _importer = importer;

    public FolderImportResult ImportFolder(string folder)
    {
        var runs = new List<Run>();
        var failures = new List<ImportFailure>();

        foreach (var file in Directory.EnumerateFiles(folder, "*.xml", SearchOption.AllDirectories).OrderBy(f => f))
        {
            if (!_importer.CanImport(file))
            {
                continue;
            }

            try
            {
                runs.Add(_importer.Import(file));
            }
            catch (Exception ex)
            {
                failures.Add(new ImportFailure(file, ex.Message));
            }
        }

        return new FolderImportResult(runs, failures);
    }
}
