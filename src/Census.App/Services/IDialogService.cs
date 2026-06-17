namespace Census.App.Services;

public interface IDialogService
{
    Task<string?> OpenProjectAsync();
    Task<string?> CreateProjectAsync();
    Task<string?> OpenImportFileAsync();
    Task<string?> OpenImportFolderAsync();
    Task<string?> SaveReportAsync(string suggestedName);
    Task<string?> SaveArchiveAsync(string suggestedName);

    /// <summary>Show a modal Replace/Cancel confirmation. Returns true if the user confirms.</summary>
    Task<bool> ConfirmAsync(string title, string message);

    /// <summary>Show a modal informational message with a single OK button.</summary>
    Task ShowMessageAsync(string title, string message);
}
