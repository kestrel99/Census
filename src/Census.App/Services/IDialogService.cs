namespace Census.App.Services;

public interface IDialogService
{
    Task<string?> OpenProjectAsync();
    Task<string?> CreateProjectAsync();
    Task<string?> OpenImportFileAsync();
    Task<string?> OpenImportFolderAsync();
    Task<string?> SaveReportAsync(string suggestedName);
    Task<string?> SaveArchiveAsync(string suggestedName);
}
