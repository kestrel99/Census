using System.IO.Compression;
using System.Text.Json;
using Census.Archive;
using Census.Domain;
using Xunit;

namespace Census.Tests;

public sealed class ArchiveTests
{
    // -----------------------------------------------------------------------
    // Test 1 — existing files are included in the ZIP
    // -----------------------------------------------------------------------
    [Fact]
    public void Archive_ExistingFiles_ZipContainsEntries()
    {
        var file1 = Path.GetTempFileName();
        var file2 = Path.GetTempFileName();
        var zipPath = Path.ChangeExtension(Path.GetTempFileName(), ".zip");

        try
        {
            File.WriteAllText(file1, "content1");
            File.WriteAllText(file2, "content2");

            var run = new Run
            {
                RunNo = "1",
                Files =
                [
                    new FileArtifact { Role = "output", Path = file1 },
                    new FileArtifact { Role = "output", Path = file2 },
                ],
            };

            new RunArchiver().Archive(run, zipPath, includeData: true);

            using var archive = ZipFile.OpenRead(zipPath);
            Assert.Equal(3, archive.Entries.Count); // 2 files + manifest
        }
        finally
        {
            TryDelete(file1, file2, zipPath);
        }
    }

    // -----------------------------------------------------------------------
    // Test 2 — data-role artifacts are skipped when includeData = false
    // -----------------------------------------------------------------------
    [Fact]
    public void Archive_SkipsDataRoleWhenFlagFalse()
    {
        var outputFile = Path.GetTempFileName();
        var dataFile = Path.GetTempFileName();
        var zipPath = Path.ChangeExtension(Path.GetTempFileName(), ".zip");

        try
        {
            File.WriteAllText(outputFile, "output");
            File.WriteAllText(dataFile, "data");

            var run = new Run
            {
                RunNo = "2",
                Files =
                [
                    new FileArtifact { Role = "output", Path = outputFile },
                    new FileArtifact { Role = "data",   Path = dataFile   },
                ],
            };

            new RunArchiver().Archive(run, zipPath, includeData: false);

            using var archive = ZipFile.OpenRead(zipPath);
            Assert.Equal(2, archive.Entries.Count); // 1 output + manifest
        }
        finally
        {
            TryDelete(outputFile, dataFile, zipPath);
        }
    }

    // -----------------------------------------------------------------------
    // Test 3 — missing files are silently skipped (no exception)
    // -----------------------------------------------------------------------
    [Fact]
    public void Archive_MissingFilesSkipped()
    {
        var zipPath = Path.ChangeExtension(Path.GetTempFileName(), ".zip");

        try
        {
            var run = new Run
            {
                RunNo = "3",
                Files =
                [
                    new FileArtifact { Role = "output", Path = @"C:\does\not\exist\file.xml" },
                ],
            };

            // Must not throw.
            new RunArchiver().Archive(run, zipPath, includeData: true);

            using var archive = ZipFile.OpenRead(zipPath);
            Assert.Single(archive.Entries); // manifest only
        }
        finally
        {
            TryDelete(zipPath);
        }
    }

    // -----------------------------------------------------------------------
    // Test 4 — manifest JSON contains the run number
    // -----------------------------------------------------------------------
    [Fact]
    public void Archive_ManifestContainsRunNo()
    {
        var zipPath = Path.ChangeExtension(Path.GetTempFileName(), ".zip");

        try
        {
            var run = new Run { RunNo = "27" };

            new RunArchiver().Archive(run, zipPath, includeData: true);

            using var archive = ZipFile.OpenRead(zipPath);
            var manifestEntry = archive.GetEntry("census_manifest.json");
            Assert.NotNull(manifestEntry);

            using var stream = manifestEntry.Open();
            var doc = JsonDocument.Parse(stream);
            Assert.Equal("27", doc.RootElement.GetProperty("RunNo").GetString());
        }
        finally
        {
            TryDelete(zipPath);
        }
    }

    // -----------------------------------------------------------------------
    // Test 5 — duplicate filenames in different directories get unique entries
    // -----------------------------------------------------------------------
    [Fact]
    public void Archive_DuplicateFilenames_UniqueEntries()
    {
        // Create two temp directories so we can give both files the same name.
        var dir1 = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        var dir2 = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        var zipPath = Path.ChangeExtension(Path.GetTempFileName(), ".zip");

        try
        {
            Directory.CreateDirectory(dir1);
            Directory.CreateDirectory(dir2);

            const string sharedName = "run27.xml";
            var file1 = Path.Combine(dir1, sharedName);
            var file2 = Path.Combine(dir2, sharedName);

            File.WriteAllText(file1, "v1");
            File.WriteAllText(file2, "v2");

            var run = new Run
            {
                RunNo = "27",
                Files =
                [
                    new FileArtifact { Role = "output", Path = file1 },
                    new FileArtifact { Role = "output", Path = file2 },
                ],
            };

            new RunArchiver().Archive(run, zipPath, includeData: true);

            using var archive = ZipFile.OpenRead(zipPath);
            Assert.Equal(3, archive.Entries.Count); // 2 files + manifest

            // All entry names must be distinct (case-insensitive).
            var names = archive.Entries.Select(e => e.FullName).ToList();
            Assert.Equal(names.Count, names.Distinct(StringComparer.OrdinalIgnoreCase).Count());
        }
        finally
        {
            TryDelete(zipPath);
            TryDeleteDirectory(dir1);
            TryDeleteDirectory(dir2);
        }
    }

    // -----------------------------------------------------------------------
    // Helpers
    // -----------------------------------------------------------------------
    private static void TryDelete(params string[] paths)
    {
        foreach (var p in paths)
        {
            try { if (File.Exists(p)) File.Delete(p); } catch { /* best-effort */ }
        }
    }

    private static void TryDeleteDirectory(string path)
    {
        try { if (Directory.Exists(path)) Directory.Delete(path, recursive: true); } catch { /* best-effort */ }
    }
}
