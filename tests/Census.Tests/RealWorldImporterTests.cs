using Census.Import;
using Xunit;

namespace Census.Tests;

/// <summary>
/// OPTIONAL extended sweep over the full, uncommitted NONMEM corpus on a developer machine.
///
/// This is NOT the importer's regression coverage — that lives in
/// <see cref="NonmemFixtureCorpusTests"/> and <see cref="NonmemGroundTruthTests"/>, which run a
/// committed fixture subset on every CI build and fail when it is absent. These tests only add
/// breadth (all ~69 runs × 4 IQ packages) when the full corpus happens to be present, and they
/// no-op otherwise so they never turn CI green on the strength of files CI cannot see.
///
/// To run them, point <c>CENSUS_NONMEM_CORPUS</c> at a folder whose subdirectories contain the
/// NONMEM <c>Reference</c> output (or rely on the default download locations below).
/// </summary>
public sealed class RealWorldImporterTests
{
    private static List<string> ReferenceDirs()
    {
        var root = Environment.GetEnvironmentVariable("CENSUS_NONMEM_CORPUS");
        if (!string.IsNullOrWhiteSpace(root) && Directory.Exists(root))
        {
            return Directory.EnumerateDirectories(root, "Reference", SearchOption.AllDirectories).ToList();
        }

        // Convenience fallback to the IQ package layout used during initial porting.
        string[] defaults =
        [
            @"C:\Users\justin\Downloads\NONMEM_tests\NONMEM730_IQ_160323\Reference",
            @"C:\Users\justin\Downloads\NONMEM_tests\NONMEM743_IQ_180814\Reference",
            @"C:\Users\justin\Downloads\NONMEM_tests\NONMEM750_IQ_210204\Reference",
            @"C:\Users\justin\Downloads\NONMEM_tests\NONMEM760_IQ_250422\Reference",
        ];
        return defaults.Where(Directory.Exists).ToList();
    }

    [Fact]
    public void Import_AllRealFiles_NoExceptions()
    {
        var dirs = ReferenceDirs();
        if (dirs.Count == 0) return; // optional supplement — see class summary.

        var importer = new NonmemXmlImporter();
        var failures = new List<string>();

        foreach (var dir in dirs)
        {
            foreach (var file in Directory.EnumerateFiles(dir, "*.xml").OrderBy(f => f))
            {
                try
                {
                    var run = importer.Import(file);

                    // Sanity-check the result structure.
                    Assert.NotNull(run.RunNo);
                    Assert.NotEmpty(run.RunNo);
                    foreach (var est in run.Estimations)
                    {
                        Assert.NotNull(est.Method);
                        Assert.True(est.Parameters.All(p => p.Estimate.HasValue || p.StandardError == null),
                            $"{file}: parameter without estimate has a standard error");
                    }
                }
                catch (Exception ex)
                {
                    failures.Add($"{file}: {ex.GetType().Name}: {ex.Message}");
                }
            }
        }

        Assert.Empty(failures);
    }

    [Fact]
    public void Import_AllRealFiles_ReportsKeyFields()
    {
        var dirs = ReferenceDirs();
        if (dirs.Count == 0) return; // optional supplement — see class summary.

        var importer = new NonmemXmlImporter();

        // Count files where each optional field is populated, as a coverage check.
        int total = 0, withObsRecs = 0, withIndividuals = 0;
        int withEstimations = 0, withShrinkage = 0, withConditionNumber = 0;

        foreach (var dir in dirs)
        {
            foreach (var file in Directory.EnumerateFiles(dir, "*.xml"))
            {
                var run = importer.Import(file);
                total++;

                if (run.ObsRecs.HasValue) withObsRecs++;
                if (run.Individuals.HasValue) withIndividuals++;
                if (run.Estimations.Count > 0) withEstimations++;

                foreach (var est in run.Estimations)
                {
                    if (est.Parameters.Any(p => p.Shrinkage.HasValue)) withShrinkage++;
                    if (est.ConditionNumber.HasValue)
                    {
                        withConditionNumber++;
                        // Computed condition numbers must be positive and finite.
                        Assert.True(est.ConditionNumber.Value > 0 && double.IsFinite(est.ConditionNumber.Value),
                            $"{file}: non-positive/non-finite condition number {est.ConditionNumber.Value}");
                    }
                }
            }
        }

        // At least half of all files should have estimations.
        Assert.True(withEstimations >= total / 2,
            $"Only {withEstimations}/{total} files had estimations");

        // Most files with estimations should have shrinkage (real NONMEM output always includes it).
        Assert.True(withShrinkage >= withEstimations / 2,
            $"Only {withShrinkage}/{withEstimations} estimation files had shrinkage");

        // Condition numbers are now derived from the correlation matrix, so runs with a
        // successful covariance step must populate them (previously always null on NM 7.3).
        Assert.True(withConditionNumber > 0,
            $"No files produced a condition number out of {withEstimations} with estimations");
    }
}
