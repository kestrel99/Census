using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;
using Census.App.Services;
using Census.App.ViewModels;
using Census.App.Views;
using Census.Storage;

namespace Census.App;

public partial class App : Application
{
    public override void Initialize() => AvaloniaXamlLoader.Load(this);

    public override void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            var settings = new JsonSettingsService();
            // Apply the saved grid font size before the main window resolves the resource.
            Resources["GridFontSize"] = settings.Load().GridFontSize;

            desktop.MainWindow = new MainWindow
            {
                DataContext = new MainWindowViewModel(
                    new SqliteProjectStore(),
                    new AvaloniaDialogService(),
                    settings),
            };
        }

        base.OnFrameworkInitializationCompleted();
    }
}
