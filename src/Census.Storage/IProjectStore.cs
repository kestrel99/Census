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

    /// <summary>Delete a run (and its estimations, parameters, warnings and file refs) by run number.</summary>
    void DeleteRun(string runNo);

    /// <summary>Set a run's flag colour (0 = unflagged, 1-5 = colour index).</summary>
    void SetFlag(string runNo, int flag);

    /// <summary>Update a run's editable metadata (parent and comment).</summary>
    void UpdateRun(string runNo, string? parentNo, string? comment);
}
