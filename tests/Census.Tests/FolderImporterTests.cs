using Census.Import;
using Xunit;

namespace Census.Tests;

public sealed class FolderImporterTests : IDisposable
{
    private readonly string _dir = Path.Combine(
        Path.GetTempPath(), $"census-folder-{Guid.NewGuid():N}");

    public FolderImporterTests() => Directory.CreateDirectory(_dir);

    [Fact]
    public void ImportFolder_ReportsParsedRunsAndPerFileFailures()
    {
        // A valid fixture, copied in twice under different run numbers.
        var good = Path.Combine(AppContext.BaseDirectory, "fixtures", "nonmem", "nm750", "runR001.xml");
        File.Copy(good, Path.Combine(_dir, "run10.xml"));
        File.Copy(good, Path.Combine(_dir, "run11.xml"));

        // A malformed XML file that must be reported as a failure, not silently skipped.
        File.WriteAllText(Path.Combine(_dir, "broken12.xml"), "<not-valid-nonmem><unclosed>");

        var result = new FolderImporter(new NonmemXmlImporter()).ImportFolder(_dir);

        Assert.Equal(2, result.Runs.Count);

        var failure = Assert.Single(result.Failures);
        Assert.EndsWith("broken12.xml", failure.Path);
        Assert.False(string.IsNullOrWhiteSpace(failure.Error));
    }

    [Fact]
    public void ImportFolder_EmptyFolder_YieldsNothing()
    {
        var result = new FolderImporter(new NonmemXmlImporter()).ImportFolder(_dir);
        Assert.Empty(result.Runs);
        Assert.Empty(result.Failures);
    }

    public void Dispose()
    {
        if (Directory.Exists(_dir))
        {
            Directory.Delete(_dir, recursive: true);
        }
    }
}
