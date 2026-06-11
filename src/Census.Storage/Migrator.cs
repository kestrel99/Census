using System.Globalization;
using System.Reflection;
using System.Text.RegularExpressions;
using Dapper;
using Microsoft.Data.Sqlite;

namespace Census.Storage;

/// <summary>
/// Minimal forward-only migration runner. Embedded <c>NNNN_name.sql</c> scripts are applied
/// in numeric order inside a transaction, and the highest applied version is recorded in a
/// <c>schema_version</c> metadata table. Idempotent: already-applied scripts are skipped.
/// </summary>
public static partial class Migrator
{
    public static void Apply(SqliteConnection connection)
    {
        connection.Execute(
            "CREATE TABLE IF NOT EXISTS schema_version (" +
            "Version INTEGER NOT NULL PRIMARY KEY, AppliedUtc TEXT NOT NULL);");

        var current = connection.ExecuteScalar<long?>(
            "SELECT MAX(Version) FROM schema_version") ?? 0;

        foreach (var (version, sql) in LoadScripts())
        {
            if (version <= current)
            {
                continue;
            }

            using var tx = connection.BeginTransaction();
            connection.Execute(sql, transaction: tx);
            connection.Execute(
                "INSERT INTO schema_version (Version, AppliedUtc) VALUES (@version, @applied);",
                new { version, applied = DateTime.UtcNow.ToString("O", CultureInfo.InvariantCulture) },
                tx);
            tx.Commit();
        }
    }

    /// <summary>The schema version this build expects (the highest embedded script).</summary>
    public static int LatestVersion() => LoadScripts().Max(s => s.Version);

    private static List<(int Version, string Sql)> LoadScripts()
    {
        var assembly = Assembly.GetExecutingAssembly();
        var scripts = new List<(int Version, string Sql)>();

        foreach (var resource in assembly.GetManifestResourceNames())
        {
            if (!resource.EndsWith(".sql", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var match = VersionPrefix().Match(resource);
            if (!match.Success)
            {
                continue;
            }

            using var stream = assembly.GetManifestResourceStream(resource)!;
            using var reader = new StreamReader(stream);
            scripts.Add((int.Parse(match.Groups[1].Value, CultureInfo.InvariantCulture), reader.ReadToEnd()));
        }

        return scripts.OrderBy(s => s.Version).ToList();
    }

    // Matches the NNNN_ numeric prefix in a resource name like "Census.Storage.Migrations.0001_initial.sql".
    [GeneratedRegex(@"\.(\d+)_[^.]*\.sql$", RegexOptions.IgnoreCase)]
    private static partial Regex VersionPrefix();
}
