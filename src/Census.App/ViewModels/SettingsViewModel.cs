using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Census.App.Services;

namespace Census.App.ViewModels;

public sealed partial class SettingsViewModel : ObservableObject
{
    private readonly ISettingsService _settings;

    public SettingsViewModel(ISettingsService settings)
    {
        _settings = settings;
        var s = settings.Load();
        NonmemPath = s.NonmemPath ?? string.Empty;
        PsnPath    = s.PsnPath    ?? string.Empty;
        PerlPath   = s.PerlPath   ?? string.Empty;
        RPath      = s.RPath      ?? string.Empty;
    }

    [ObservableProperty] private string _nonmemPath = string.Empty;
    [ObservableProperty] private string _psnPath    = string.Empty;
    [ObservableProperty] private string _perlPath   = string.Empty;
    [ObservableProperty] private string _rPath      = string.Empty;

    [RelayCommand]
    private void Save()
    {
        _settings.UpdateSettings(s =>
        {
            s.NonmemPath = NonmemPath;
            s.PsnPath    = PsnPath;
            s.PerlPath   = PerlPath;
            s.RPath      = RPath;
        });
    }
}
