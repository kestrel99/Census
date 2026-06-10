using System.Globalization;
using Census.Domain;
using Dapper;
using Microsoft.Data.Sqlite;

namespace Census.Storage;

/// <summary>
/// SQLite-backed <see cref="IProjectStore"/> using Microsoft.Data.Sqlite and Dapper.
/// The schema is created and upgraded by the embedded migration scripts (<see cref="Migrator"/>).
/// </summary>
public sealed class SqliteProjectStore : IProjectStore
{
    private string? _path;

    private string ConnectionString =>
        new SqliteConnectionStringBuilder
        {
            DataSource = _path ?? throw new InvalidOperationException("No project is open. Call Create or Open first."),
            ForeignKeys = true,
        }.ToString();

    public void Create(string path)
    {
        _path = path;
        using var connection = OpenConnection();
        Migrator.Apply(connection);
    }

    public void Open(string path)
    {
        if (!File.Exists(path))
        {
            throw new FileNotFoundException("Project file not found.", path);
        }

        _path = path;
        using var connection = OpenConnection();
        Migrator.Apply(connection);
    }

    public void SaveRun(Run run)
    {
        using var connection = OpenConnection();
        using var tx = connection.BeginTransaction();

        var runId = connection.ExecuteScalar<long>(
            """
            INSERT INTO runs (RunNo, IRunNo, ParentNo, Comment, KeyRun, ObsRecs, Individuals, CreatedUtc)
            VALUES (@RunNo, @IRunNo, @ParentNo, @Comment, @KeyRun, @ObsRecs, @Individuals, @CreatedUtc);
            SELECT last_insert_rowid();
            """,
            new
            {
                run.RunNo,
                run.IRunNo,
                run.ParentNo,
                run.Comment,
                KeyRun = run.KeyRun ? 1 : 0,
                run.ObsRecs,
                run.Individuals,
                CreatedUtc = DateTime.UtcNow.ToString("O", CultureInfo.InvariantCulture),
            },
            tx);

        foreach (var artifact in run.Files)
        {
            connection.Execute(
                "INSERT INTO file_artifacts (RunId, Role, Path, Md5) VALUES (@runId, @Role, @Path, @Md5);",
                new { runId, artifact.Role, artifact.Path, artifact.Md5 },
                tx);
        }

        foreach (var estimation in run.Estimations)
        {
            var estId = connection.ExecuteScalar<long>(
                """
                INSERT INTO estimations (RunId, Number, Method, Ofv, DOfv, ConditionNumber)
                VALUES (@runId, @Number, @Method, @Ofv, @DOfv, @ConditionNumber);
                SELECT last_insert_rowid();
                """,
                new { runId, estimation.Number, estimation.Method, estimation.Ofv, estimation.DOfv, estimation.ConditionNumber },
                tx);

            foreach (var p in estimation.Parameters)
            {
                connection.Execute(
                    """
                    INSERT INTO parameters (EstimationId, Kind, "Index", Label, Estimate, StandardError, Shrinkage)
                    VALUES (@estId, @Kind, @Index, @Label, @Estimate, @StandardError, @Shrinkage);
                    """,
                    new { estId, Kind = p.Kind.ToString().ToLowerInvariant(), p.Index, p.Label, p.Estimate, p.StandardError, p.Shrinkage },
                    tx);
            }

            foreach (var warning in estimation.Warnings)
            {
                connection.Execute(
                    "INSERT INTO warnings (EstimationId, Text) VALUES (@estId, @warning);",
                    new { estId, warning },
                    tx);
            }
        }

        tx.Commit();
    }

    public IReadOnlyList<Run> GetRuns()
    {
        using var connection = OpenConnection();

        var runRows = connection.Query<RunRow>(
            "SELECT Id, RunNo, IRunNo, ParentNo, Comment, KeyRun, ObsRecs, Individuals FROM runs ORDER BY IRunNo;")
            .ToList();

        var runs = new List<Run>(runRows.Count);
        foreach (var r in runRows)
        {
            var files = connection.Query<FileArtifact>(
                "SELECT Role, Path, Md5 FROM file_artifacts WHERE RunId = @id ORDER BY Id;",
                new { id = r.Id }).ToList();

            var estRows = connection.Query<EstimationRow>(
                "SELECT Id, Number, Method, Ofv, DOfv, ConditionNumber FROM estimations WHERE RunId = @id ORDER BY Number;",
                new { id = r.Id }).ToList();

            var estimations = new List<Estimation>(estRows.Count);
            foreach (var e in estRows)
            {
                var parameters = connection.Query<ParameterRow>(
                    """SELECT Kind, "Index", Label, Estimate, StandardError, Shrinkage FROM parameters WHERE EstimationId = @id ORDER BY Id;""",
                    new { id = e.Id })
                    .Select(p => new Parameter
                    {
                        Kind = Enum.Parse<ParameterKind>(p.Kind, ignoreCase: true),
                        Index = (int)p.Index,
                        Label = p.Label,
                        Estimate = p.Estimate,
                        StandardError = p.StandardError,
                        Shrinkage = p.Shrinkage,
                    })
                    .ToList();

                var warnings = connection.Query<string>(
                    "SELECT Text FROM warnings WHERE EstimationId = @id ORDER BY Id;",
                    new { id = e.Id }).ToList();

                estimations.Add(new Estimation
                {
                    Number = (int)e.Number,
                    Method = e.Method,
                    Ofv = e.Ofv,
                    DOfv = e.DOfv,
                    ConditionNumber = e.ConditionNumber,
                    Parameters = parameters,
                    Warnings = warnings,
                });
            }

            runs.Add(new Run
            {
                RunNo = r.RunNo,
                IRunNo = (int)r.IRunNo,
                ParentNo = r.ParentNo,
                Comment = r.Comment,
                KeyRun = r.KeyRun != 0,
                ObsRecs = (int?)r.ObsRecs,
                Individuals = (int?)r.Individuals,
                Files = files,
                Estimations = estimations,
            });
        }

        return runs;
    }

    private SqliteConnection OpenConnection()
    {
        var connection = new SqliteConnection(ConnectionString);
        connection.Open();
        return connection;
    }

    // Row DTOs for Dapper mapping. SQLite returns INTEGER columns as Int64, so these use
    // long/long? to match; conversion to the domain's int types happens at the call site.
    private sealed record RunRow(long Id, string RunNo, long IRunNo, string? ParentNo, string? Comment, long KeyRun, long? ObsRecs, long? Individuals);

    private sealed record EstimationRow(long Id, long Number, string? Method, double? Ofv, double? DOfv, double? ConditionNumber);

    private sealed record ParameterRow(string Kind, long Index, string? Label, double? Estimate, double? StandardError, double? Shrinkage);
}
