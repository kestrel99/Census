using Avalonia;
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
        NonmemPath   = s.NonmemPath ?? string.Empty;
        PsnPath      = s.PsnPath    ?? string.Empty;
        PerlPath     = s.PerlPath   ?? string.Empty;
        RPath        = s.RPath      ?? string.Empty;
        GridFontSize = (decimal)s.GridFontSize;
    }

    [ObservableProperty] private string _nonmemPath = string.Empty;
    [ObservableProperty] private string _psnPath    = string.Empty;
    [ObservableProperty] private string _perlPath   = string.Empty;
    [ObservableProperty] private string _rPath      = string.Empty;
    [ObservableProperty] private decimal _gridFontSize = 11;

    [RelayCommand]
    private void Save()
    {
        var fontSize = (double)GridFontSize;
        _settings.UpdateSettings(s =>
        {
            s.NonmemPath   = NonmemPath;
            s.PsnPath      = PsnPath;
            s.PerlPath     = PerlPath;
            s.RPath        = RPath;
            s.GridFontSize = fontSize;
        });

        // Apply the new grid font size live to all open grids.
        if (Application.Current is { } app)
            app.Resources["GridFontSize"] = fontSize;
    }
}
