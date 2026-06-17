using System.Collections.ObjectModel;
using System.IO;
using Avalonia.Controls.ApplicationLifetimes;
using Census.App.Services;
using Census.App.Views;
using Census.Archive;
using Census.Domain;
using Census.Import;
using Census.Reports;
using Census.Storage;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

namespace Census.App.ViewModels;

public partial class MainWindowViewModel : ObservableObject
{
    private readonly IProjectStore _store;
    private readonly IDialogService _dialogs;
    private readonly ISettingsService _settings;

    public MainWindowViewModel(IProjectStore store, IDialogService dialogs, ISettingsService settings)
    {
        _store = store;
        _dialogs = dialogs;
        _settings = settings;
        RefreshRecentProjects();
    }

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(Title))]
    [NotifyPropertyChangedFor(nameof(IsProjectOpen))]
    [NotifyPropertyChangedFor(nameof(ConnectionStatus))]
    [NotifyCanExecuteChangedFor(nameof(ImportRunCommand))]
    [NotifyCanExecuteChangedFor(nameof(ImportFolderCommand))]
    [NotifyCanExecuteChangedFor(nameof(CompareCommand))]
    private string? _projectPath;

    [ObservableProperty]
    private ObservableCollection<string> _recentProjects = [];

    [ObservableProperty]
    private ObservableCollection<RunSummaryViewModel> _runs = [];

    [ObservableProperty]
    private ObservableCollection<RunTreeNode> _runTree = [];

    [ObservableProperty]
    private RunTreeNode? _selectedTreeNode;

    [ObservableProperty]
    private bool _treeExpanded = true;

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(ExportRunCommand))]
    [NotifyCanExecuteChangedFor(nameof(ArchiveRunCommand))]
    [NotifyCanExecuteChangedFor(nameof(DeleteRunCommand))]
    [NotifyCanExecuteChangedFor(nameof(DiagnosticsCommand))]
    private RunSummaryViewModel? _selectedRun;

    [ObservableProperty]
    private RunDetailViewModel? _runDetail;

    partial void OnSelectedRunChanged(RunSummaryViewModel? value)
    {
        RunDetail = value is not null ? new RunDetailViewModel(value.Model) : null;
    }

    partial void OnSelectedTreeNodeChanged(RunTreeNode? value)
    {
        if (value?.Run is not null)
            SelectedRun = value.Run;
    }

    partial void OnTreeExpandedChanged(bool value)
    {
        foreach (var node in RunTree)
            node.IsExpanded = value;
    }

    public bool IsProjectOpen => ProjectPath is not null;
    public bool IsRunSelected => SelectedRun is not null;

    public string Title => ProjectPath is not null
        ? $"Census — {Path.GetFileName(ProjectPath)}"
        : "Census";

    public string ConnectionStatus => ProjectPath is not null
        ? $"Connected – {ProjectPath}"
        : "Not connected";

    public string StatusText { get; private set; } = "No project open";

    private void UpdateStatusText(string text)
    {
        StatusText = text;
        OnPropertyChanged(nameof(StatusText));
    }

    [RelayCommand]
    private async Task NewProjectAsync()
    {
        var path = await _dialogs.CreateProjectAsync();
        if (path is null) return;
        _store.Create(path);
        ProjectPath = path;
        RefreshRuns();
        _settings.AddRecentProject(path);
        RefreshRecentProjects();
    }

    [RelayCommand]
    private async Task OpenProjectAsync()
    {
        var path = await _dialogs.OpenProjectAsync();
        if (path is null) return;
        LoadProject(path);
    }

    [RelayCommand]
    private void CloseProject()
    {
        SelectedRun = null;
        ProjectPath = null;
        Runs.Clear();
        RunTree = [];
        UpdateStatusText("No project open");
    }

    [RelayCommand]
    private void Exit()
    {
        if (Avalonia.Application.Current?.ApplicationLifetime is
            Avalonia.Controls.ApplicationLifetimes.IClassicDesktopStyleApplicationLifetime lifetime)
            lifetime.Shutdown();
    }

    [RelayCommand(CanExecute = nameof(IsProjectOpen))]
    private async Task ImportRunAsync()
    {
        var path = await _dialogs.OpenImportFileAsync();
        if (path is null) return;

        var importer = new NonmemXmlImporter();
        if (!importer.CanImport(path))
        {
            UpdateStatusText("Only NONMEM XML output (.xml) can be imported.");
            return;
        }

        try
        {
            var run = importer.Import(path);

            if (_store.RunExists(run.IRunNo))
            {
                var replace = await _dialogs.ConfirmAsync(
                    "Run already exists",
                    $"Run {run.RunNo} already exists in this project.\n\nReplace it with the newly imported " +
                    "results? Your comment, flag and parent run will be kept.");
                if (!replace)
                {
                    UpdateStatusText($"Import cancelled — run {run.RunNo} already exists.");
                    return;
                }

                _store.ReplaceRun(run);
                RefreshRuns();
                UpdateStatusText($"Replaced run {run.RunNo}.");
                return;
            }

            _store.SaveRun(run);
            RefreshRuns();
            UpdateStatusText($"Imported run {run.RunNo}.");
        }
        catch (Exception ex)
        {
            UpdateStatusText($"Import failed: {ex.Message}");
        }
    }

    [RelayCommand(CanExecute = nameof(IsProjectOpen))]
    private async Task ImportFolderAsync()
    {
        var folder = await _dialogs.OpenImportFolderAsync();
        if (folder is null) return;

        var scan = new FolderImporter(new NonmemXmlImporter()).ImportFolder(folder);
        var failures = scan.Failures.ToList();

        // Ask once whether to replace any runs that already exist, rather than prompting per file.
        var existing = scan.Runs.Count(r => _store.RunExists(r.IRunNo));
        var replaceExisting = false;
        if (existing > 0)
        {
            replaceExisting = await _dialogs.ConfirmAsync(
                "Some runs already exist",
                $"{existing} of the imported runs already exist in this project.\n\nReplace them with the " +
                "newly imported results? Comments, flags and parents will be kept. Choose Cancel to skip " +
                "them and import only new runs.");
        }

        int imported = 0, replaced = 0, skipped = 0;
        foreach (var run in scan.Runs)
        {
            try
            {
                if (_store.RunExists(run.IRunNo))
                {
                    if (replaceExisting) { _store.ReplaceRun(run); replaced++; }
                    else { skipped++; }
                }
                else
                {
                    _store.SaveRun(run);
                    imported++;
                }
            }
            catch (Exception ex)
            {
                var source = run.Files.FirstOrDefault()?.Path ?? $"run {run.RunNo}";
                failures.Add(new ImportFailure(source, ex.Message));
            }
        }

        if (imported + replaced > 0) RefreshRuns();
        UpdateStatusText($"Imported {imported}, replaced {replaced}, skipped {skipped}, {failures.Count} failed.");

        if (failures.Count > 0)
        {
            var details = string.Join("\n", failures.Select(f => $"• {Path.GetFileName(f.Path)} — {f.Error}"));
            await _dialogs.ShowMessageAsync(
                "Some files could not be imported",
                $"{failures.Count} file(s) failed to import:\n\n{details}");
        }
    }

    [RelayCommand(CanExecute = nameof(IsRunSelected))]
    private void SetFlag(string? flag)
    {
        if (SelectedRun is null || !int.TryParse(flag, out var value)) return;
        var runNo = SelectedRun.RunNo;
        _store.SetFlag(runNo, value);
        RefreshRuns();
        SelectedRun = Runs.FirstOrDefault(r => r.RunNo == runNo);
    }

    [RelayCommand(CanExecute = nameof(IsRunSelected))]
    private async Task EditRunAsync()
    {
        if (SelectedRun is null) return;

        var others = Runs.Select(r => r.RunNo).Where(n => n != SelectedRun.RunNo);
        var vm = new EditRunViewModel(SelectedRun.Model, others);
        var win = new EditRunWindow { DataContext = vm };
        var owner = (Avalonia.Application.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow;
        if (owner is null) return;

        if (!await win.ShowDialog<bool>(owner)) return;

        var runNo = SelectedRun.RunNo;
        _store.UpdateRun(runNo, string.IsNullOrWhiteSpace(vm.ParentNo) ? null : vm.ParentNo, vm.Comment);
        RefreshRuns();
        SelectedRun = Runs.FirstOrDefault(r => r.RunNo == runNo);
    }

    [RelayCommand(CanExecute = nameof(IsRunSelected))]
    private void DeleteRun()
    {
        if (SelectedRun is null) return;
        var runNo = SelectedRun.RunNo;
        _store.DeleteRun(runNo);
        SelectedRun = null;
        RefreshRuns();
        UpdateStatusText($"Deleted run {runNo}.");
    }

    private readonly List<RunSummaryViewModel> _compareSelection = [];

    public bool CanCompare => IsProjectOpen && _compareSelection.Count >= 2;

    /// <summary>Receives the run grid's current multi-selection (called from the view).</summary>
    public void SetCompareSelection(System.Collections.IList? items)
    {
        _compareSelection.Clear();
        if (items is not null)
        {
            foreach (var item in items)
            {
                if (item is RunSummaryViewModel run)
                    _compareSelection.Add(run);
            }
        }
        CompareCommand.NotifyCanExecuteChanged();
    }

    [RelayCommand(CanExecute = nameof(CanCompare))]
    private async Task CompareAsync()
    {
        var runs = _compareSelection.Select(r => r.Model).ToList();
        if (runs.Count < 2)
        {
            UpdateStatusText("Select two or more runs to compare (Ctrl/Shift-click).");
            return;
        }

        var win = new CompareWindow(new CompareViewModel(runs));
        var owner = (Avalonia.Application.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow;
        if (owner is not null)
            await win.ShowDialog(owner);
    }

    [RelayCommand(CanExecute = nameof(IsRunSelected))]
    private void Diagnostics() =>
        UpdateStatusText("Diagnostics view is planned.");

    [RelayCommand(CanExecute = nameof(IsRunSelected))]
    private async Task ExportRunAsync()
    {
        if (SelectedRun is null) return;
        var path = await _dialogs.SaveReportAsync("csv");
        if (path is null) return;
        var ext = Path.GetExtension(path).TrimStart('.').ToLowerInvariant();
        IReportWriter writer = ext switch
        {
            "html" => new HtmlReportWriter(),
            "tex"  => new LatexReportWriter(),
            _      => new CsvReportWriter(),
        };
        var run = _store.GetRuns().FirstOrDefault(r => r.RunNo == SelectedRun.RunNo);
        if (run is null) return;
        var content = writer.Render(run);
        await File.WriteAllTextAsync(path, content);
        UpdateStatusText($"Exported {SelectedRun.RunNo} to {Path.GetFileName(path)}.");
    }

    [RelayCommand(CanExecute = nameof(IsRunSelected))]
    private async Task ArchiveRunAsync()
    {
        if (SelectedRun is null) return;
        var path = await _dialogs.SaveArchiveAsync("zip");
        if (path is null) return;
        var run = _store.GetRuns().FirstOrDefault(r => r.RunNo == SelectedRun.RunNo);
        if (run is null) return;
        var archiver = new RunArchiver();
        await Task.Run(() => archiver.Archive(run, path, includeData: true));
        UpdateStatusText($"Archived {SelectedRun.RunNo} to {Path.GetFileName(path)}.");
    }

    [RelayCommand]
    private async Task OpenRecentProjectAsync(string path)
    {
        if (!File.Exists(path))
        {
            UpdateStatusText($"Project not found: {Path.GetFileName(path)}");
            return;
        }
        LoadProject(path);
        await Task.CompletedTask;
    }

    [RelayCommand]
    private async Task OpenSettingsAsync()
    {
        var vm = new SettingsViewModel(_settings);
        var win = new SettingsWindow { DataContext = vm };
        var owner = (Avalonia.Application.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow;
        if (owner is not null)
            await win.ShowDialog(owner);
    }

    private void RefreshRecentProjects()
    {
        RecentProjects = new ObservableCollection<string>(_settings.GetRecentProjects());
    }

    private void LoadProject(string path)
    {
        try
        {
            _store.Open(path);
            ProjectPath = path;
            RefreshRuns();
            _settings.AddRecentProject(path);
            RefreshRecentProjects();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Failed to open project: {ex.Message}");
        }
    }

    private void RefreshRuns()
    {
        var all = _store.GetRuns();
        var byRunNo = all.ToDictionary(r => r.RunNo, r => r);
        Runs = new ObservableCollection<RunSummaryViewModel>(
            all.Select(r => new RunSummaryViewModel(r, byRunNo)));
        OnPropertyChanged(nameof(Runs));
        RebuildRunTree();
        UpdateStatusText(ProjectPath is not null
            ? $"{Runs.Count} run{(Runs.Count == 1 ? "" : "s")} | {Path.GetFileName(ProjectPath)}"
            : "No project open");
    }

    private void RebuildRunTree()
    {
        var root = new RunTreeNode("All runs", null) { IsExpanded = TreeExpanded };
        foreach (var run in Runs)
        {
            var label = string.IsNullOrEmpty(run.Comment) ? run.RunNo : $"{run.RunNo}  —  {run.Comment}";
            root.Children.Add(new RunTreeNode(label, run));
        }
        RunTree = [root];
    }
}
