# Census

Census is a NONMEM run tracking and project management tool.

This repository is mid-port. The application is being rewritten from its original
Lazarus / Object Pascal implementation to a cross-platform **C# / .NET 10 + Avalonia**
codebase. The original code is preserved as a behavioral reference, not as the structure
to reproduce.

## Repository layout

| Path | Contents |
| --- | --- |
| `src/` | New .NET solution projects (domain, import, storage, reports, archive, external tools, CLI, Avalonia app). |
| `tests/` | Test project (xUnit + Verify). |
| `Census.slnx` | Solution file. |
| `Directory.Build.props`, `Directory.Packages.props`, `global.json` | Shared build settings and Central Package Management. |
| `legacy/` | The original Lazarus / Object Pascal application, archived as the behavioral oracle. Not built by the .NET solution. |
| `PORTING_STRATEGY.md` | Why and how the port is being done, and the alternatives considered. |
| `IMPLEMENTATION_PLAN.md` | Concrete build plan, dependencies, and phased task breakdown. |

## Building the new codebase

Requires the **.NET 10 SDK** (only prerequisite).

```sh
dotnet restore Census.slnx
dotnet build   Census.slnx -c Release
dotnet test    Census.slnx -c Release
```

Run the headless CLI:

```sh
dotnet run --project src/Census.Cli -- --help
```

Produce a single self-contained binary (no runtime install required):

```sh
dotnet publish src/Census.Cli -c Release -r win-x64 \
  --self-contained true -p:PublishSingleFile=true
```

(Substitute `osx-arm64`, `osx-x64`, or `linux-x64` for other platforms.)

## License

Census is licensed under the GNU LGPL. See [LICENSE](LICENSE).
