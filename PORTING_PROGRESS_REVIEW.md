# Census Porting Progress Review

Date: 2026-06-12
Updated: 2026-06-19

## Summary

The Avalonia/.NET port has a credible foundation and has since closed every
import-correctness and consistency gap that did not require external resources.
The strongest areas are project scaffolding, SQLite migrations, NONMEM XML
parsing, report rendering, archiving, a committed fixture oracle, honest import
behavior, and an Avalonia shell. The largest remaining gaps are PsN import,
legacy listing import, external tool and R workflows, and signed release
packaging — all of which need inputs that are not yet available (fixture
files, a target PsN version, signing credentials).

`dotnet test` currently passes: **68 passed, 0 failed** (was 46 at the original
review).

## Resolved Since The Original Review (2026-06-12)

The following items from this review have been addressed (newest first; each is a
single commit on `master`):

- **Quality Notes** (`8ee1e0f`): `NonmemXmlImporter.ImportXml` is now static
  (CA1822); `ComputeMd5` documents MD5 as a legacy non-cryptographic fingerprint
  with a justified suppression (CA5351); `JsonSettingsService` logs load/save
  failures via `Trace.TraceError` instead of swallowing them.
- **Canonical dOFV** (`4a69d65`): dOFV is now a single derived quantity
  (`Census.Domain.OfvAnalysis`), never stored. The unused persisted
  `Estimation.DOfv` field and its DB column were removed (migration `0004`).
  Grid/list derive vs the parent run; Compare derives vs the first selected run —
  all through one shared helper.
- **Folder-import failure reporting** (`32ae8df`): a new `FolderImporter` service
  captures per-file failures (path + error); the CLI prints a "Failed imports"
  table and the GUI surfaces them in a dialog. No more silent skips.
- **Duplicate imports** (`f52367a`): re-importing an existing run number now warns
  and, on confirmation, replaces the run while preserving user annotations
  (parent, flag, non-empty comment); otherwise it skips. CLI gains
  `--replace`/`--skip-existing`; the GUI prompts. `RunExists`/`ReplaceRun` added
  to storage.
- **Import honesty** (`e426c07`): CLI/UI/API text says XML-only (was "XML or
  listing"); the GUI picker dropped its misleading "All Files" filter and guards
  with `CanImport`.
- **Fixture oracle** (`f1fcdb3`): a representative NONMEM corpus is committed
  (runs R001/R027/R041 × NM 7.3/7.4.3/7.5.0). `NonmemFixtureCorpusTests`
  hard-fails when the corpus is absent and snapshots a readable oracle table;
  `NonmemGroundTruthTests` anchors correctness against NONMEM's raw `.ext`/`.shk`
  output. The old local-only sweep is now an explicit, opt-in supplement.

## Remaining Gaps For Port Parity

These need inputs or decisions that were not available during the work above.

### 1. PsN Support Is Not Implemented

The legacy app had PsN support and a `psn` table. The current app has a PsN tab
that says results are not yet available, but there is no PsN domain model,
importer, storage mapping, CLI support, or UI workflow.

Blocked on: real PsN output folders to use as committed fixtures, and a target
PsN version to design against.

Required work:

- Define PsN domain/storage representation.
- Add PsN fixture sets by supported PsN version.
- Implement PsN importer and CLI/UI entry points.
- Replace the placeholder PsN tab with real data.

### 2. Legacy Listing (.lst) Import Is Not Implemented

Only `NonmemXmlImporter` (`.xml`) exists; `.lst` is explicitly rejected. The
import text is now honest about this (XML-only), but listing import remains a
real feature gap if parity is desired.

Blocked on: representative NONMEM `.lst` listing files to use as fixtures/oracle.

Required work:

- Implement a listing importer behind committed fixtures.
- Add import dispatch instead of hard-wiring `NonmemXmlImporter`.
- Restore the "XML or listing" affordances once support exists.

### 3. External Tool And R Integration Is Only A Stub

Settings store paths for NONMEM, PsN, Perl, and R, but those paths are not used by
any workflow. `ProcessRunner` is a generic synchronous process launcher that
returns only an exit code; it does not capture output/errors, support
cancellation/progress, or implement R-over-stdin.

Required work:

- Replace the generic runner with workflow-level services:
  `RunNonmem`, `RunPsn`, `RunPerl`, and `RunRCommand` or equivalent.
- Use `ProcessStartInfo.ArgumentList` instead of manual quoting.
- Capture stdout/stderr and expose logs to CLI/UI.
- Support cancellation and progress.
- Add tests for argument handling and failure reporting.

## Optional Behavioral Work (Not Yet Started)

### Table File Editing And MD5s

Legacy edit supported assigning `sdtab`, `patab`, `catab`, `cotab`, `mytab`, and
`mutab` files and calculating MD5 values. The new edit workflow only updates
parent and comment.

Needs a product decision: is table-file reassignment still a supported workflow?
If so, add UI fields, storage updates, MD5 calculation, and archive/export
integration.

### Compare View/Export

The UI Compare view shows OFV, dOFV (vs first selected run), condition number, and
parameter estimates. Legacy compare also included SE/RSE/shrinkage/metadata and
CSV export.

Required work (if parity is desired):

- Add SE/RSE/shrinkage/metadata rows.
- Add CSV export for compare results.

## Packaging And Release Gaps

CI publishes single-file artifacts on tags, but signing is still a TODO. Both
`PORTING_STRATEGY.md` and `IMPLEMENTATION_PLAN.md` call Windows code signing an
early high-priority deliverable.

Blocked on: Windows signing credentials or Azure Trusted Signing provisioning.

Required work:

- Provision Windows signing credentials or Azure Trusted Signing.
- Wire signing into the tagged Windows publish job.
- Add macOS signing/notarization before distributing macOS builds.
- Decide whether Linux AppImage packaging is required for the first public release.

## Quality Notes

- `dotnet test` passes 68 tests.
- The original CA1822 (`ImportXml`) and CA5351 (MD5) warnings are resolved.
- One pre-existing `CA1822` remains on `MainWindowViewModel.Exit`; it was left
  untouched because it is a `[RelayCommand]` method and making it static risks
  breaking the source generator. It was not part of the original review's notes.
- The codebase still emits broader `CA1305`/`CA1826` analyzer noise project-wide;
  this is tolerated (no `TreatWarningsAsErrors`) and is a separate cleanup.

## Suggested Next Milestone

The import-correctness foundation is done. The next high-value milestones all
need external inputs; pick based on what becomes available:

1. **PsN or listing import** — start whichever has fixtures available first, as a
   self-contained milestone with committed fixtures and an oracle.
2. **Release signing** — wire signing into the tagged Windows publish once
   credentials exist; the highest-leverage step toward a distributable build.
3. **External tool / R workflows** — replace the `ProcessRunner` stub with real
   workflow services once a runnable NONMEM/PsN/R environment is available.

Input-independent options if the above are blocked:

- Compare CSV export and broadened compare rows (SE/RSE/shrinkage/metadata).
