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
    [NotifyCanExecuteChangedFor(nameof(ImportRunCommand))]
    [NotifyCanExecuteChangedFor(nameof(ImportFolderCommand))]
    private string? _projectPath;

    [ObservableProperty]
    private ObservableCollection<string> _recentProjects = [];

    [ObservableProperty]
    private ObservableCollection<RunSummaryViewModel> _runs = [];

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(ExportRunCommand))]
    [NotifyCanExecuteChangedFor(nameof(ArchiveRunCommand))]
    private RunSummaryViewModel? _selectedRun;

    [ObservableProperty]
    private RunDetailViewModel? _runDetail;

    partial void OnSelectedRunChanged(RunSummaryViewModel? value)
    {
        RunDetail = value is not null ? new RunDetailViewModel(value.Model) : null;
    }

    public bool IsProjectOpen => ProjectPath is not null;
    public bool IsRunSelected => SelectedRun is not null;

    public string Title => ProjectPath is not null
        ? $"Census — {Path.GetFileName(ProjectPath)}"
        : "Census";
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
        Runs.Clear();
        _settings.AddRecentProject(path);
        RefreshRecentProjects();
        UpdateStatusText($"0 runs | {Path.GetFileName(path)}");
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
        ProjectPath = null;
        Runs.Clear();
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
        var run = new NonmemXmlImporter().Import(path);
        _store.SaveRun(run);
        RefreshRuns();
    }

    [RelayCommand(CanExecute = nameof(IsProjectOpen))]
    private async Task ImportFolderAsync()
    {
        var folder = await _dialogs.OpenImportFolderAsync();
        if (folder is null) return;
        var importer = new NonmemXmlImporter();
        var files = Directory.EnumerateFiles(folder, "*.xml", SearchOption.AllDirectories).ToList();
        int imported = 0;
        foreach (var file in files)
        {
            try
            {
                var run = importer.Import(file);
                _store.SaveRun(run);
                imported++;
            }
            catch { /* skip unparseable files */ }
        }
        if (imported > 0) RefreshRuns();
        UpdateStatusText($"Imported {imported} of {files.Count} XML files.");
    }

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
        UpdateStatusText(ProjectPath is not null
            ? $"{Runs.Count} run{(Runs.Count == 1 ? "" : "s")} | {Path.GetFileName(ProjectPath)}"
            : "No project open");
    }
}
