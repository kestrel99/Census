using Census.Domain;

namespace Census.Storage;

/// <summary>
/// Reads and writes a Census project (<c>.cen</c> SQLite file). The schema is defined
/// cleanly for Microsoft.Data.Sqlite and versioned via migrations from the first release;
/// there is no backward compatibility with Lazarus-era databases.
/// </summary>
public interface IProjectStore
{
    /// <summary>Create a new project file with the current schema.</summary>
    void Create(string path);

    /// <summary>Open an existing project, applying any pending migrations.</summary>
    void Open(string path);

    /// <summary>Persist a run.</summary>
    void SaveRun(Run run);

    /// <summary>Load all runs in the project.</summary>
    IReadOnlyList<Run> GetRuns();
}
