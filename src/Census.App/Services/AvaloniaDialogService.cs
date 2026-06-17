using Avalonia;
using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Layout;
using Avalonia.Media;
using Avalonia.Platform.Storage;

namespace Census.App.Services;

public sealed class AvaloniaDialogService : IDialogService
{
    private static Window MainWindow =>
        ((IClassicDesktopStyleApplicationLifetime)Application.Current!.ApplicationLifetime!).MainWindow!;

    public async Task<string?> OpenProjectAsync()
    {
        var files = await TopLevel.GetTopLevel(MainWindow)!.StorageProvider.OpenFilePickerAsync(
            new FilePickerOpenOptions
            {
                Title = "Open Census Project",
                AllowMultiple = false,
                FileTypeFilter = [new FilePickerFileType("Census Project") { Patterns = ["*.cen"] }],
            });
        return files.Count > 0 ? files[0].TryGetLocalPath() : null;
    }

    public async Task<string?> CreateProjectAsync()
    {
        var file = await TopLevel.GetTopLevel(MainWindow)!.StorageProvider.SaveFilePickerAsync(
            new FilePickerSaveOptions
            {
                Title = "Create Census Project",
                SuggestedFileName = "project.cen",
                FileTypeChoices = [new FilePickerFileType("Census Project") { Patterns = ["*.cen"] }],
            });
        return file?.TryGetLocalPath();
    }

    public async Task<string?> OpenImportFileAsync()
    {
        var files = await TopLevel.GetTopLevel(MainWindow)!.StorageProvider.OpenFilePickerAsync(
            new FilePickerOpenOptions
            {
                Title = "Import NONMEM Run",
                AllowMultiple = false,
                // XML output is the only supported import format today; don't offer "All Files".
                FileTypeFilter = [
                    new FilePickerFileType("NONMEM XML Output") { Patterns = ["*.xml"] },
                ],
            });
        return files.Count > 0 ? files[0].TryGetLocalPath() : null;
    }

    public async Task<string?> OpenImportFolderAsync()
    {
        var folders = await TopLevel.GetTopLevel(MainWindow)!.StorageProvider.OpenFolderPickerAsync(
            new FolderPickerOpenOptions
            {
                Title = "Import Folder",
                AllowMultiple = false,
            });
        return folders.Count > 0 ? folders[0].TryGetLocalPath() : null;
    }

    public async Task<string?> SaveReportAsync(string suggestedName)
    {
        var file = await TopLevel.GetTopLevel(MainWindow)!.StorageProvider.SaveFilePickerAsync(
            new FilePickerSaveOptions
            {
                Title = "Export Report",
                SuggestedFileName = suggestedName,
                FileTypeChoices = [
                    new FilePickerFileType("HTML") { Patterns = ["*.html"] },
                    new FilePickerFileType("CSV") { Patterns = ["*.csv"] },
                    new FilePickerFileType("LaTeX") { Patterns = ["*.tex"] },
                ],
            });
        return file?.TryGetLocalPath();
    }

    public async Task<string?> SaveArchiveAsync(string suggestedName)
    {
        var file = await TopLevel.GetTopLevel(MainWindow)!.StorageProvider.SaveFilePickerAsync(
            new FilePickerSaveOptions
            {
                Title = "Archive Run",
                SuggestedFileName = suggestedName,
                FileTypeChoices = [new FilePickerFileType("ZIP Archive") { Patterns = ["*.zip"] }],
            });
        return file?.TryGetLocalPath();
    }

    public async Task<bool> ConfirmAsync(string title, string message)
    {
        var confirmed = false;
        var dialog = new Window
        {
            Title = title,
            Width = 440,
            SizeToContent = SizeToContent.Height,
            CanResize = false,
            WindowStartupLocation = WindowStartupLocation.CenterOwner,
        };

        var replace = new Button { Content = "Replace", IsDefault = true, MinWidth = 90 };
        var cancel = new Button { Content = "Cancel", IsCancel = true, MinWidth = 90 };
        replace.Click += (_, _) => { confirmed = true; dialog.Close(); };
        cancel.Click += (_, _) => { confirmed = false; dialog.Close(); };

        dialog.Content = new StackPanel
        {
            Margin = new Thickness(20),
            Spacing = 20,
            Children =
            {
                new TextBlock { Text = message, TextWrapping = TextWrapping.Wrap },
                new StackPanel
                {
                    Orientation = Orientation.Horizontal,
                    HorizontalAlignment = HorizontalAlignment.Right,
                    Spacing = 10,
                    Children = { cancel, replace },
                },
            },
        };

        await dialog.ShowDialog(MainWindow);
        return confirmed;
    }

    public async Task ShowMessageAsync(string title, string message)
    {
        var dialog = new Window
        {
            Title = title,
            Width = 480,
            MaxHeight = 480,
            SizeToContent = SizeToContent.Height,
            CanResize = false,
            WindowStartupLocation = WindowStartupLocation.CenterOwner,
        };

        var ok = new Button { Content = "OK", IsDefault = true, IsCancel = true, MinWidth = 90 };
        ok.Click += (_, _) => dialog.Close();

        dialog.Content = new StackPanel
        {
            Margin = new Thickness(20),
            Spacing = 20,
            Children =
            {
                new ScrollViewer
                {
                    MaxHeight = 340,
                    Content = new TextBlock { Text = message, TextWrapping = TextWrapping.Wrap },
                },
                new StackPanel
                {
                    Orientation = Orientation.Horizontal,
                    HorizontalAlignment = HorizontalAlignment.Right,
                    Children = { ok },
                },
            },
        };

        await dialog.ShowDialog(MainWindow);
    }
}
