using System.IO.Compression;
using System.Text.Json;
using Census.Domain;

namespace Census.Archive;

/// <summary>
/// Creates a ZIP archive containing a run's file artifacts and a JSON manifest.
/// </summary>
public sealed class RunArchiver : IRunArchiver
{
    /// <inheritdoc />
    public void Archive(Run run, string destinationZip, bool includeData)
    {
        // Delete existing zip so we can use ZipArchiveMode.Create cleanly.
        if (File.Exists(destinationZip))
            File.Delete(destinationZip);

        // Track entry names already used so we can de-duplicate.
        var usedNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        // Manifest tracks the entries that were actually added.
        var manifestFiles = new List<ManifestFile>();

        using var archive = new ZipArchive(File.Create(destinationZip), ZipArchiveMode.Create, leaveOpen: false);

        foreach (var artifact in run.Files)
        {
            // Skip missing files.
            if (!File.Exists(artifact.Path))
                continue;

            // Skip data-role artifacts when includeData is false.
            if (!includeData && string.Equals(artifact.Role, "data", StringComparison.OrdinalIgnoreCase))
                continue;

            var entryName = MakeUniqueEntryName(Path.GetFileName(artifact.Path), usedNames);
            usedNames.Add(entryName);

            var entry = archive.CreateEntry(entryName, CompressionLevel.Optimal);
            using (var entryStream = entry.Open())
            using (var sourceStream = File.OpenRead(artifact.Path))
            {
                sourceStream.CopyTo(entryStream);
            }

            manifestFiles.Add(new ManifestFile(artifact.Role, entryName, artifact.Md5));
        }

        // Build and write the manifest.
        var lastEstimation = run.Estimations.Count > 0 ? run.Estimations[^1] : null;

        var manifest = new RunManifest(
            RunNo: run.RunNo,
            Method: lastEstimation?.Method,
            OFV: lastEstimation?.Ofv,
            Individuals: run.Individuals,
            ObsRecs: run.ObsRecs,
            Files: manifestFiles
        );

        var manifestEntry = archive.CreateEntry("census_manifest.json", CompressionLevel.Optimal);
        using var manifestStream = manifestEntry.Open();
        JsonSerializer.Serialize(manifestStream, manifest, ManifestJsonContext.Default.RunManifest);
    }

    private static string MakeUniqueEntryName(string filename, HashSet<string> usedNames)
    {
        if (!usedNames.Contains(filename))
            return filename;

        var nameWithoutExt = Path.GetFileNameWithoutExtension(filename);
        var ext = Path.GetExtension(filename);
        var counter = 2;

        string candidate;
        do
        {
            candidate = $"{nameWithoutExt}_{counter}{ext}";
            counter++;
        }
        while (usedNames.Contains(candidate));

        return candidate;
    }
}

// DTO types used only for serialization — kept internal to this file.

internal sealed record ManifestFile(string Role, string Path, string? Md5);

internal sealed record RunManifest(
    string RunNo,
    string? Method,
    double? OFV,
    int? Individuals,
    int? ObsRecs,
    IReadOnlyList<ManifestFile> Files
);

[System.Text.Json.Serialization.JsonSerializable(typeof(RunManifest))]
[System.Text.Json.Serialization.JsonSerializable(typeof(ManifestFile))]
[System.Text.Json.Serialization.JsonSourceGenerationOptions(WriteIndented = true)]
internal sealed partial class ManifestJsonContext : System.Text.Json.Serialization.JsonSerializerContext
{
}
