using System.Text.Json;
using Census.App.Models;

namespace Census.App.Services;

public sealed class JsonSettingsService : ISettingsService
{
    private static readonly string SettingsPath = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
        "Census", "settings.json");

    private AppSettings _cache = new();

    public JsonSettingsService() => _cache = Load();

    public AppSettings Load()
    {
        try
        {
            if (File.Exists(SettingsPath))
            {
                var json = File.ReadAllText(SettingsPath);
                return JsonSerializer.Deserialize<AppSettings>(json) ?? new AppSettings();
            }
        }
        catch { /* ignore corrupt settings */ }
        return new AppSettings();
    }

    public void Save(AppSettings settings)
    {
        _cache = settings;
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(SettingsPath)!);
            File.WriteAllText(SettingsPath, JsonSerializer.Serialize(settings, new JsonSerializerOptions { WriteIndented = true }));
        }
        catch { /* ignore save failures */ }
    }

    public void AddRecentProject(string path)
    {
        _cache.RecentProjects.Remove(path);
        _cache.RecentProjects.Insert(0, path);
        if (_cache.RecentProjects.Count > 10) _cache.RecentProjects.RemoveRange(10, _cache.RecentProjects.Count - 10);
        Save(_cache);
    }

    public IReadOnlyList<string> GetRecentProjects() => _cache.RecentProjects.AsReadOnly();
}
