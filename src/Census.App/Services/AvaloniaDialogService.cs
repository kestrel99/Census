using Avalonia;
using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
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
                FileTypeFilter = [
                    new FilePickerFileType("NONMEM XML Output") { Patterns = ["*.xml"] },
                    new FilePickerFileType("All Files") { Patterns = ["*"] },
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
}
