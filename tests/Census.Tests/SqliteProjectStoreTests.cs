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
        Assert.True(run.KeyRun);
        Assert.Equal(1234, run.ObsRecs);

        var artifact = Assert.Single(run.Files);
        Assert.Equal("output", artifact.Role);
        Assert.Equal("run27.lst", artifact.Path);
        Assert.Equal("abc123", artifact.Md5);

        var est = Assert.Single(run.Estimations);
        Assert.Equal("FOCEI", est.Method);
        Assert.Equal(-1234.56, est.Ofv);
        Assert.Equal(12.3, est.ConditionNumber);
        Assert.Equal("Rounding errors", Assert.Single(est.Warnings));

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
        KeyRun = true,
        ObsRecs = 1234,
        Individuals = 56,
        Files = [new FileArtifact { Role = "output", Path = "run27.lst", Md5 = "abc123" }],
        Estimations =
        [
            new Estimation
            {
                Number = 1,
                Method = "FOCEI",
                Ofv = -1234.56,
                DOfv = -10.0,
                ConditionNumber = 12.3,
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
