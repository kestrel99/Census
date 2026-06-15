using Census.Domain;
using Census.Import;
using Xunit;

namespace Census.Tests;

/// <summary>
/// Independent correctness anchor for the importer (the "hybrid" oracle).
///
/// Unlike the golden snapshot in <see cref="NonmemFixtureCorpusTests"/> — which trusts whatever
/// the current parser produces — these expected values were read by hand from NONMEM's own raw
/// ancillary output for run R001, which is ground truth independent of both Census and the legacy
/// Lazarus app:
///   • final estimates + OFV  ← runR001.ext, record ITERATION = -1000000000
///   • standard errors        ← runR001.ext, record ITERATION = -1000000001
///   • eta shrinkage (%SD)    ← runR001.shk, TYPE 4
///
/// The three committed formats (7.3 / 7.4.3 / 7.5.0) agree to ~5 significant figures, so a single
/// expected set with a small tolerance covers all of them. If you later capture values from the
/// Lazarus app for additional runs, add them here in the same shape as a second anchor.
/// </summary>
public sealed class NonmemGroundTruthTests
{
    private static string CorpusDir =>
        Path.Combine(AppContext.BaseDirectory, "fixtures", "nonmem");

    [Theory]
    [InlineData("nm73")]
    [InlineData("nm743")]
    [InlineData("nm750")]
    public void RunR001_MatchesRawNonmemOutput(string version)
    {
        var path = Path.Combine(CorpusDir, version, "runR001.xml");
        var run = new NonmemXmlImporter().ImportXml(File.ReadAllText(path), path);

        var est = Assert.Single(run.Estimations);
        Assert.Equal("FOCEI", est.Method, ignoreCase: true);

        // OFV from the .ext final-estimates record.
        Approx(-4126.1148, est.Ofv, "OFV");

        // THETA final estimates and standard errors (.ext records -1000000000 / -1000000001).
        ApproxParam(est, ParameterKind.Theta, 1, estimate: 3.98013, se: 0.0989759);
        ApproxParam(est, ParameterKind.Theta, 2, estimate: 68.2194, se: 1.92949);
        ApproxParam(est, ParameterKind.Theta, 3, estimate: 0.199472, se: 0.00280475);

        // OMEGA diagonal final estimates, standard errors, and eta shrinkage (.shk TYPE 4).
        ApproxParam(est, ParameterKind.Omega, 1, estimate: 0.0715555, se: 0.00912817, shrinkage: 1.37216);
        ApproxParam(est, ParameterKind.Omega, 2, estimate: 0.0921585, se: 0.0122009, shrinkage: 1.46175);
    }

    private static void ApproxParam(
        Estimation est, ParameterKind kind, int index,
        double estimate, double? se = null, double? shrinkage = null)
    {
        var p = est.Parameters.SingleOrDefault(x => x.Kind == kind && x.Index == index);
        Assert.True(p is not null, $"{kind} {index} not found");

        Approx(estimate, p!.Estimate, $"{kind}{index} estimate");
        if (se.HasValue)
        {
            Approx(se.Value, p.StandardError, $"{kind}{index} SE");
        }

        if (shrinkage.HasValue)
        {
            Approx(shrinkage.Value, p.Shrinkage, $"{kind}{index} shrinkage");
        }
    }

    // Tolerance is loose enough to absorb trailing-digit drift between NONMEM versions but far
    // tighter than any real parser regression (which would mis-read a whole column).
    private static void Approx(double expected, double? actual, string what)
    {
        Assert.True(actual.HasValue, $"{what}: expected {expected} but value was null");
        var tol = 1e-3 * Math.Abs(expected) + 1e-4;
        Assert.True(Math.Abs(actual!.Value - expected) <= tol,
            $"{what}: expected ≈{expected} (±{tol:G3}) but was {actual.Value}");
    }
}
