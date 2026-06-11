using System.Collections.ObjectModel;
using Census.App.Services;
using Census.Domain;
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
    }

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(Title))]
    [NotifyPropertyChangedFor(nameof(StatusText))]
    [NotifyPropertyChangedFor(nameof(IsProjectOpen))]
    private string? _projectPath;

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(StatusText))]
    private ObservableCollection<RunSummaryViewModel> _runs = [];

    [ObservableProperty]
    private RunSummaryViewModel? _selectedRun;

    public bool IsProjectOpen => ProjectPath is not null;
    public string Title => ProjectPath is not null
        ? $"Census — {Path.GetFileName(ProjectPath)}"
        : "Census";
    public string StatusText => ProjectPath is not null
        ? $"{Runs.Count} run{(Runs.Count == 1 ? "" : "s")} | {Path.GetFileName(ProjectPath)}"
        : "No project open";

    [RelayCommand]
    private async Task NewProjectAsync()
    {
        var path = await _dialogs.CreateProjectAsync();
        if (path is null) return;
        _store.Create(path);
        ProjectPath = path;
        Runs.Clear();
        _settings.AddRecentProject(path);
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
    }

    [RelayCommand]
    private void Exit()
    {
        if (Avalonia.Application.Current?.ApplicationLifetime is
            Avalonia.Controls.ApplicationLifetimes.IClassicDesktopStyleApplicationLifetime lifetime)
            lifetime.Shutdown();
    }

    private void LoadProject(string path)
    {
        try
        {
            _store.Open(path);
            ProjectPath = path;
            RefreshRuns();
            _settings.AddRecentProject(path);
        }
        catch (Exception ex)
        {
            // TODO: show error dialog when compare/import dialogs are implemented in Task 3
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
        OnPropertyChanged(nameof(StatusText));
    }
}
