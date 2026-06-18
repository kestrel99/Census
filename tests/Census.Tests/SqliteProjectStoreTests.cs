using Census.Domain;
using Census.Storage;
using Microsoft.Data.Sqlite;
using Xunit;

namespace Census.Tests;

public sealed class SqliteProjectStoreTests : IDisposable
{
    private readonly string _path = Path.Combine(
        Path.GetTempPath(), $"census-test-{Guid.NewGuid():N}.cen");

    [Fact]
    public void Create_ThenSaveAndReload_RoundTripsRun()
    {
        var store = new SqliteProjectStore();
        store.Create(_path);
        store.SaveRun(SampleRun());

        // Reopen with a fresh store to prove persistence, not in-memory state.
        var reopened = new SqliteProjectStore();
        reopened.Open(_path);
        var runs = reopened.GetRuns();

        var run = Assert.Single(runs);
        Assert.Equal("27", run.RunNo);
        Assert.Equal(27, run.IRunNo);
        Assert.Equal("12", run.ParentNo);
        Assert.Equal(3, run.Flag);
        Assert.Equal(1234, run.ObsRecs);

        var artifact = Assert.Single(run.Files);
        Assert.Equal("output", artifact.Role);
        Assert.Equal("run27.lst", artifact.Path);
        Assert.Equal("abc123", artifact.Md5);

        Assert.Equal("2024-01-15T10:30:00", run.StartDateTime);
        Assert.Equal("2024-01-15T10:45:00", run.StopDateTime);
        Assert.Equal(900.0, run.TotalCpuTime);
        Assert.Equal(1.5, run.PostElapsedTime);
        Assert.Equal(0.7, run.FinalOutputElapsedTime);

        var est = Assert.Single(run.Estimations);
        Assert.Equal("FOCEI", est.Method);
        Assert.Equal(-1234.56, est.Ofv);
        Assert.Equal(12.3, est.ConditionNumber);
        Assert.Equal(123.4, est.EstimationTime);
        Assert.Equal(45.6, est.CovarianceTime);
        Assert.Equal("Rounding errors", Assert.Single(est.Warnings));

        Assert.NotNull(est.Correlation);
        Assert.Equal(["CL", "V"], est.Correlation!.Labels);
        Assert.Equal(0.25, est.Correlation.Values[1][0]!.Value);
        Assert.NotNull(est.Covariance);
        Assert.Equal(0.02, est.Covariance!.Values[0][0]!.Value);

        Assert.Equal(2, est.Parameters.Count);
        var theta = Assert.Single(est.Parameters, p => p.Kind == ParameterKind.Theta);
        Assert.Equal(1, theta.Index);
        Assert.Equal("CL", theta.Label);
        Assert.Equal(3.21, theta.Estimate);
        Assert.Equal(0.15, theta.StandardError);

        var omega = Assert.Single(est.Parameters, p => p.Kind == ParameterKind.Omega);
        Assert.Equal(0.42, omega.Shrinkage);
    }

    [Fact]
    public void SetFlag_And_UpdateRun_Persist()
    {
        var store = new SqliteProjectStore();
        store.Create(_path);
        store.SaveRun(SampleRun());

        store.SetFlag("27", 5);
        store.UpdateRun("27", parentNo: "9", comment: "edited comment");

        var reopened = new SqliteProjectStore();
        reopened.Open(_path);
        var run = Assert.Single(reopened.GetRuns());

        Assert.Equal(5, run.Flag);
        Assert.Equal("9", run.ParentNo);
        Assert.Equal("edited comment", run.Comment);
    }

    [Fact]
    public void SaveRun_DuplicateRunNumber_Throws()
    {
        var store = new SqliteProjectStore();
        store.Create(_path);
        store.SaveRun(SampleRun());

        Assert.False(store.RunExists(99));
        Assert.True(store.RunExists(27));

        // A plain second insert of the same run number violates the unique index.
        Assert.ThrowsAny<SqliteException>(() => store.SaveRun(SampleRun()));
    }

    [Fact]
    public void ReplaceRun_OverwritesData_ButKeepsUserAnnotations()
    {
        var store = new SqliteProjectStore();
        store.Create(_path);
        store.SaveRun(SampleRun());

        // The user annotates the imported run.
        store.SetFlag("27", 5);
        store.UpdateRun("27", parentNo: "9", comment: "my edited note");

        // Re-import the same run number with fresh NONMEM data and no annotations
        // (as a real importer would produce: parent null, flag 0, problem-title comment).
        var reimport = SampleRun() with
        {
            ParentNo = null,
            Flag = 0,
            Comment = "PK base model",
            Estimations =
            [
                new Estimation { Number = 1, Method = "FOCEI", Ofv = -2000.0 },
            ],
        };
        store.ReplaceRun(reimport);

        var reopened = new SqliteProjectStore();
        reopened.Open(_path);
        var run = Assert.Single(reopened.GetRuns());

        // New estimation data replaced the old.
        Assert.Equal(-2000.0, Assert.Single(run.Estimations).Ofv);

        // User annotations survived the re-import.
        Assert.Equal(5, run.Flag);
        Assert.Equal("9", run.ParentNo);
        Assert.Equal("my edited note", run.Comment);
    }

    [Fact]
    public void ReplaceRun_WhenAbsent_InsertsAndUsesImportComment()
    {
        var store = new SqliteProjectStore();
        store.Create(_path);

        var run = SampleRun() with { Comment = "import comment" };
        store.ReplaceRun(run); // no existing run with this number

        var reopened = new SqliteProjectStore();
        reopened.Open(_path);
        var loaded = Assert.Single(reopened.GetRuns());
        Assert.Equal("import comment", loaded.Comment);
        Assert.Equal(3, loaded.Flag);
    }

    [Fact]
    public void Open_AppliesMigrationsIdempotently()
    {
        new SqliteProjectStore().Create(_path);

        // Opening again must not throw or duplicate schema.
        var store = new SqliteProjectStore();
        store.Open(_path);

        Assert.Empty(store.GetRuns());
        Assert.Equal(Migrator.LatestVersion(), AppliedSchemaVersion());
    }

    private long AppliedSchemaVersion()
    {
        using var connection = new SqliteConnection(
            new SqliteConnectionStringBuilder { DataSource = _path }.ToString());
        connection.Open();
        using var command = connection.CreateCommand();
        command.CommandText = "SELECT MAX(Version) FROM schema_version;";
        return Convert.ToInt64(command.ExecuteScalar(), System.Globalization.CultureInfo.InvariantCulture);
    }

    private static Run SampleRun() => new()
    {
        RunNo = "27",
        IRunNo = 27,
        ParentNo = "12",
        Comment = "base model",
        Flag = 3,
        ObsRecs = 1234,
        Individuals = 56,
        StartDateTime = "2024-01-15T10:30:00",
        StopDateTime = "2024-01-15T10:45:00",
        TotalCpuTime = 900.0,
        PostElapsedTime = 1.5,
        FinalOutputElapsedTime = 0.7,
        Files = [new FileArtifact { Role = "output", Path = "run27.lst", Md5 = "abc123" }],
        Estimations =
        [
            new Estimation
            {
                Number = 1,
                Method = "FOCEI",
                Ofv = -1234.56,
                ConditionNumber = 12.3,
                EstimationTime = 123.4,
                CovarianceTime = 45.6,
                Correlation = new NamedMatrix
                {
                    Labels = ["CL", "V"],
                    Values = [[0.15], [0.25, 0.80]],
                },
                Covariance = new NamedMatrix
                {
                    Labels = ["CL", "V"],
                    Values = [[0.02], [0.01, 0.64]],
                },
                Warnings = ["Rounding errors"],
                Parameters =
                [
                    new Parameter { Kind = ParameterKind.Theta, Index = 1, Label = "CL", Estimate = 3.21, StandardError = 0.15 },
                    new Parameter { Kind = ParameterKind.Omega, Index = 1, Label = "IIV-CL", Estimate = 0.09, StandardError = 0.02, Shrinkage = 0.42 },
                ],
            },
        ],
    };

    public void Dispose()
    {
        SqliteConnection.ClearAllPools();
        if (File.Exists(_path))
        {
            File.Delete(_path);
        }
    }
}
