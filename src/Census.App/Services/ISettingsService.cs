using Census.App.Models;

namespace Census.App.Services;

public interface ISettingsService
{
    AppSettings Load();
    void Save(AppSettings settings);
    void AddRecentProject(string path);
    IReadOnlyList<string> GetRecentProjects();
}
