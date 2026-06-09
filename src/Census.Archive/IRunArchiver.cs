using Census.Domain;

namespace Census.Archive;

/// <summary>
/// Creates a ZIP archive of a run and its file artifacts using in-box
/// System.IO.Compression.
/// </summary>
public interface IRunArchiver
{
    /// <summary>Archive the run's artifacts to <paramref name="destinationZip"/>.</summary>
    void Archive(Run run, string destinationZip, bool includeData);
}
