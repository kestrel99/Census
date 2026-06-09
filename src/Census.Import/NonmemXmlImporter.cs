using Census.Domain;

namespace Census.Import;

/// <summary>
/// Imports NONMEM 7.2+ XML output. The modern import path and the first to be implemented.
/// Replaces the generated <c>nmoutput.pas</c> bindings with schema-aware traversal into
/// typed domain objects.
/// </summary>
public sealed class NonmemXmlImporter : IRunImporter
{
    public bool CanImport(string sourcePath) =>
        sourcePath.EndsWith(".xml", StringComparison.OrdinalIgnoreCase);

    public Run Import(string sourcePath) =>
        throw new NotImplementedException("NONMEM XML import — phase 3.");
}
