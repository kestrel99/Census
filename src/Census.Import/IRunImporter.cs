using Census.Domain;

namespace Census.Import;

/// <summary>
/// Imports a NONMEM run from a source artifact into a <see cref="Run"/>. The only implementation
/// today is <see cref="NonmemXmlImporter"/> (NONMEM <c>.xml</c> output); listing-file and PsN-folder
/// import are planned but not yet available. Implementations are the regression-critical core and
/// must be tested against the fixture oracle (see IMPLEMENTATION_PLAN.md, phase 1).
/// </summary>
public interface IRunImporter
{
    /// <summary>True if this importer recognizes the given source path.</summary>
    bool CanImport(string sourcePath);

    /// <summary>Parse the source into a domain <see cref="Run"/>.</summary>
    Run Import(string sourcePath);
}
