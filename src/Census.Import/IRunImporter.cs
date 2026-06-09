using Census.Domain;

namespace Census.Import;

/// <summary>
/// Imports a NONMEM run from a source artifact (XML output, listing file, or PsN folder)
/// into a <see cref="Run"/>. Implementations are the regression-critical core and must be
/// tested against the fixture oracle (see IMPLEMENTATION_PLAN.md, phase 1).
/// </summary>
public interface IRunImporter
{
    /// <summary>True if this importer recognizes the given source path.</summary>
    bool CanImport(string sourcePath);

    /// <summary>Parse the source into a domain <see cref="Run"/>.</summary>
    Run Import(string sourcePath);
}
