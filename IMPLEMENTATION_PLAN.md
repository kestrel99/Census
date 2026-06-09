# Census Implementation Plan (Avalonia/.NET Port)

This plan turns the decisions in [PORTING_STRATEGY.md](PORTING_STRATEGY.md) into a
concrete build. It covers the solution structure, the exact dependencies needed to
**compile** and to **distribute** on Windows, macOS, and Linux, and a phased task
breakdown with exit criteria.

Scope reminder: the current Pascal app is the **behavioral oracle**, not a format to stay
compatible with. There is no requirement to read Lazarus-era `.cen` files at runtime.

---

## 1. Target Platform and Toolchain

| Choice | Value | Rationale |
| --- | --- | --- |
| Runtime | **.NET 10 (LTS)** | Long-term support, NativeAOT and single-file support, current as of 2026. |
| Language | C# 14 | Matches .NET 10. |
| UI | **Avalonia 11 (latest 11.x)** | Self-rendered (Skia) native UI, no WebView2 dependency. |
| MVVM | CommunityToolkit.Mvvm | Source-generated, AOT/trim friendly. |
| Data | SQLite via `Microsoft.Data.Sqlite` + Dapper | Native SQLite speed, lean mapping, clean schema. |
| Tests | xUnit + Verify | Snapshot testing is ideal for report/export golden files. |

### Distribution decision: self-contained single-file first, NativeAOT later

Two ways to ship "one binary, no runtime install":

- **Self-contained single-file** (`PublishSingleFile=true --self-contained`): one `.exe`
  (~70 MB, runtime bundled). Works with **every** library, including reflection-based ones
  (Dapper, CsvHelper, Scriban). **This is the primary distribution.**
- **NativeAOT**: a true native binary, smaller and faster to start, but breaks
  reflection-heavy libraries and full XAML reflection-based bindings. **Deferred** as an
  optional optimization for the headless CLI only, where the dependency surface is small.

This ordering directly serves the "avoid dependency/install/Windows problems at all costs"
requirement: self-contained single-file is the most robust, lowest-surprise option, and we
do not gamble the GUI on AOT trimming pitfalls.

---

## 2. Solution Structure

One solution (`Census.sln`), projects matching the strategy doc's module layout:

```
Census.sln
├─ src/
│  ├─ Census.Domain/          # Pure domain models, no I/O, no framework refs
│  ├─ Census.Import/          # NONMEM XML + listing + PsN parsing, MD5, discovery
│  ├─ Census.Storage/         # SQLite schema, migrations, repositories (Dapper)
│  ├─ Census.Reports/         # CSV, HTML, LaTeX writers (templated)
│  ├─ Census.Archive/         # ZIP creation for runs + artifacts
│  ├─ Census.ExternalTools/   # Process launching: NONMEM, PsN, Perl, R
│  ├─ Census.Cli/             # `census` headless command-line tool
│  └─ Census.App/             # Avalonia MVVM desktop UI
└─ tests/
   └─ Census.Tests/           # Regression tests against fixtures + snapshots
```

Dependency direction: `Domain` depends on nothing. `Import`, `Storage`, `Reports`,
`Archive`, `ExternalTools` depend on `Domain`. `Cli` and `App` depend on the service
projects but **share the exact same services** — the GUI never reimplements logic.

---

## 3. Build (Compile-Time) Dependencies

### 3.1 Developer toolchain

| Tool | Purpose | Notes |
| --- | --- | --- |
| **.NET 10 SDK** | Build, test, publish | The only mandatory prerequisite to compile. |
| Git | Source control | — |
| IDE (Visual Studio 2022+, Rider, or VS Code + C# Dev Kit) | Development | "Clone → open → F5" — the contributor on-ramp. |
| `XmlSchemaClassGenerator` (dotnet tool) | Regenerate typed classes from NONMEM `output.xsd` | Dev-time only; replaces the generated `nmoutput.pas`. |

No C/C++ toolchain is required — `Microsoft.Data.Sqlite` bundles the native SQLite engine
via SQLitePCLRaw, and Avalonia bundles Skia.

### 3.2 NuGet packages per project

| Project | Package | Why |
| --- | --- | --- |
| `Census.Domain` | *(none)* | Keep it dependency-free and trivially testable. |
| `Census.Import` | `System.Xml` (in-box) | NONMEM XML traversal (`XDocument`/`XmlReader`). |
| | source-generated `Regex` (in-box) | Listing parsing; replaces vendored `regexpr.pas`. |
| `Census.Storage` | `Microsoft.Data.Sqlite` | Native SQLite access. |
| | `Dapper` | Fast, lean query → object mapping. |
| | `DbUp-SQLite` | Versioned, idempotent migration scripts. |
| `Census.Reports` | `Scriban` | HTML/LaTeX templating (no runtime compilation, fast, trim-friendly). |
| | `CsvHelper` | Correct CSV quoting/escaping (replaces hand-built strings). |
| `Census.Archive` | `System.IO.Compression` (in-box) | ZIP creation (replaces Lazarus `Zipper`). |
| `Census.ExternalTools` | `System.Diagnostics.Process` (in-box) | Launch NONMEM/PsN/Perl/R; R driven over stdin. |
| `Census.Cli` | `Spectre.Console.Cli` | Command parsing + formatted output (chosen over the still-prerelease `System.CommandLine`). |
| `Census.App` | `Avalonia`, `Avalonia.Desktop`, `Avalonia.Themes.Fluent`, `Avalonia.Fonts.Inter` | Core UI + modern theme. |
| | `Avalonia.Controls.DataGrid` | Run table (free, MIT). |
| | built-in `TreeView` | Run tree. **Note:** `Avalonia.Controls.TreeDataGrid` is a commercial (Avalonia Accelerate) control and is intentionally avoided. |
| | `CommunityToolkit.Mvvm` | ViewModels, commands (source-generated). |
| `Census.Tests` | `xunit`, `xunit.runner.visualstudio` | Test framework. |
| | `Verify.Xunit` | Snapshot/golden-file tests for reports and parsed values. |

Settings/options (currently INI) move to a JSON settings file via in-box
`System.Text.Json` — no external dependency, and no need to preserve the old INI format.

> **Scaffold note.** The solution is scaffolded and builds on .NET 10 / Avalonia 12 with
> Central Package Management; resolved versions live in `Directory.Packages.props`.
> `FluentAssertions` was deliberately omitted (its v8 moved to a paid commercial license);
> tests use plain xUnit asserts plus Verify. `Avalonia.Diagnostics` is omitted until a
> version matching Avalonia 12 is published.

---

## 4. Distribution Dependencies

Published with `dotnet publish -c Release -r <RID> -p:PublishSingleFile=true --self-contained true`
per target RID: `win-x64`, `osx-arm64`, `osx-x64`, `linux-x64`.

### 4.1 Windows

| Need | Tool / Dependency | Notes |
| --- | --- | --- |
| Single binary | `dotnet publish` (SDK) | Produces one self-contained `.exe`, no runtime install. |
| Installer *(optional)* | **Inno Setup** | Free, ubiquitous, produces a single signed setup `.exe`. A portable `.exe` ships alongside. |
| **Code signing** | Authenticode cert + `signtool` (Windows SDK) **or** Azure Trusted Signing | **Highest-priority distribution task.** EV/OV cert or Azure Trusted Signing minimizes SmartScreen/antivirus false positives. Provision early — certs have lead time and cost. |

### 4.2 macOS

| Need | Tool / Dependency | Notes |
| --- | --- | --- |
| Build | `dotnet publish` for `osx-arm64` + `osx-x64` | Ship both, or merge with `lipo` for a universal `.app`. |
| App bundle | `.app` layout + `Info.plist` | Standard macOS packaging. |
| **Signing + notarization** | **Apple Developer ID** ($99/yr), `codesign`, `notarytool`, `stapler` | Required or Gatekeeper blocks the app. Needs a macOS machine or macOS CI runner. |
| Disk image *(optional)* | `create-dmg` | Distributable `.dmg`. |

### 4.3 Linux

| Need | Tool / Dependency | Notes |
| --- | --- | --- |
| Build | `dotnet publish` for `linux-x64` | Self-contained single file. |
| Package | **AppImage** (primary) | Single portable file — best match for the single-binary ethos. Tarball as fallback. |
| Optional | `.deb` / `.rpm` / Flatpak | Add later if users request distro-native packages. |
| Signing | GPG *(optional)* | No mandatory signing infrastructure like Windows/macOS. |

---

## 5. Phased Task Breakdown

Each phase has a deliverable and an exit criterion. Phases 0–5 produce a **useful headless
product** before any GUI work; the GUI (phase 6) is the largest mass and comes last.

### Phase 0 — Repository & CI skeleton
- Create the solution and empty projects above; add `Directory.Packages.props` for central
  package versioning.
- Stand up GitHub Actions matrix (windows/macos/ubuntu): restore, build, test.
- **Exit:** empty solution builds and tests green on all three OSes.

### Phase 1 — Freeze current behavior (fixtures + oracle)
- Collect fixtures **now, while the Lazarus app still builds**: representative NONMEM 7.2+
  XML, legacy listing files, PsN output folders, and the **existing `.cen` files**
  (`test.cen`, `empty.db`) plus current CSV/HTML/LaTeX exports and run archives.
- Record, from the old app, the key stored values per run: run number, parent, OFV, dOFV,
  theta/omega/sigma, standard errors, shrinkage, condition number, warnings, file refs.
- **Exit:** a committed fixture corpus and a written table of expected values the new
  importer must reproduce.

### Phase 2 — Domain + clean SQLite storage
- Define `Census.Domain` models (run, estimation, theta/omega/sigma, PsN result, warning,
  file artifact).
- Design a clean schema; author DbUp migration scripts; add a schema-version metadata table
  from release one. **No ZEOS quirks carried over.**
- Implement `Census.Storage` repositories with Dapper.
- **Exit:** create/open a project file, round-trip domain objects, migrations apply
  idempotently — all under test.

### Phase 3 — NONMEM XML importer (modern path first)
- Regenerate typed XML classes from the current NONMEM `output.xsd` with
  `XmlSchemaClassGenerator`; build schema-aware traversal into domain objects.
- Add MD5 (in-box `System.Security.Cryptography`) and file discovery.
- Regression-test against phase-1 fixtures: stored values must match the oracle.
- **Exit:** XML import of fixtures reproduces the recorded values.

### Phase 4 — Reports, exports, archive
- `Census.Reports`: CSV via CsvHelper; HTML and LaTeX via Scriban templates (consistent
  LaTeX escaping). `Census.Archive`: ZIP via `System.IO.Compression`.
- Golden-file tests with Verify against the captured exports.
- **Exit:** CSV/HTML/LaTeX/archive outputs match fixtures (modulo intended improvements).

### Phase 5 — CLI, external tools, remaining importers
- `Census.Cli` with `import`, `import-folder`, `export-run`, `compare`, `archive`.
- `Census.ExternalTools`: process launching for NONMEM/PsN/Perl/R (R over stdin).
- **PsN import (major work item, own fixture set per PsN version).**
- **Legacy listing parser** (regex, behind thorough fixtures) — only if users still need it.
- **Exit:** the `census` CLI is a genuinely useful standalone product; full import/export
  pipeline runs headless in CI.

### Phase 6 — Avalonia desktop UI
- MVVM screens reproducing current workflows: project open/create/recent; run table; run
  tree; run detail tabs (theta/omega/sigma/estimation/covariance/tables); import run &
  folder; compare; export report & run record; options for NONMEM/PsN/Perl/R + filename
  conventions.
- UI binds to the **same services** the CLI uses.
- Use compiled bindings (`x:DataType`) throughout (keeps the AOT door open).
- **Exit:** desktop app drives every CLI workflow through the GUI.

### Phase 7 — Packaging, signing, release
- Per-platform publish jobs in CI producing single-file artifacts.
- **Windows code signing wired in and validated on a clean Windows VM** (top priority).
- macOS notarization; Linux AppImage. Optional Inno Setup installer.
- **Exit:** signed, downloadable artifacts for Windows/macOS/Linux from a tagged release.

---

## 6. CI/CD Pipeline

- **Trigger:** PR (build+test) and tag (build+test+publish+sign+release).
- **Matrix:** `windows-latest`, `macos-latest`, `ubuntu-latest`.
- **Steps:** `dotnet restore` → `build` → `test` (parser/storage/report snapshots run on
  every OS) → `publish` per RID → **sign** → upload artifacts / attach to GitHub Release.
- **Secrets:** Windows signing cert/Azure Trusted Signing credentials; Apple Developer ID
  cert + notarization credentials.
- Code signing is an **early** pipeline deliverable, not a final polish step.

---

## 7. Sequencing Notes & Risks

- **Capture fixtures before the old toolchain rots** (phase 1 is gating). The oracle depends
  on being able to run/inspect the Lazarus app and its outputs.
- **PsN and the regex listing parser are the brittle, under-estimated pieces** (~200 PsN
  refs and a 4,000-line regex unit in the current code). Budget them as first-class work
  with their own fixtures.
- **Provision signing certificates in phase 0–1**, not phase 7 — lead time and cost are real,
  and unsigned binaries reproduce exactly the antivirus/SmartScreen problems to be avoided.
- **Keep the GUI on compiled bindings** so a future NativeAOT build of the app remains
  feasible without a rewrite.
- The CLI delivering value before the GUI exists shortens the rewrite valley and de-risks
  the whole effort.

---

## 8. Dependency Summary (Quick Reference)

**To compile:** .NET 10 SDK (only hard prerequisite) + the NuGet packages in §3.2
(`Avalonia*`, `CommunityToolkit.Mvvm`, `Microsoft.Data.Sqlite`, `Dapper`, `DbUp-SQLite`,
`Scriban`, `CsvHelper`, `System.CommandLine`, `xunit`, `Verify.Xunit`). Dev tool:
`XmlSchemaClassGenerator`.

**To distribute:** `dotnet publish` (single-file, self-contained) for all platforms; plus
**Windows** Authenticode cert + `signtool` / Azure Trusted Signing (and optional Inno
Setup); **macOS** Apple Developer ID + `codesign`/`notarytool` (and optional `create-dmg`);
**Linux** AppImage tooling. No end-user runtime install on any platform.
