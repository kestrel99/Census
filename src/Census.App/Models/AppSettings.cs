namespace Census.App.Models;

public sealed class AppSettings
{
    public List<string> RecentProjects { get; set; } = [];
    public string NonmemPath { get; set; } = string.Empty;
    public string PsnPath { get; set; } = string.Empty;
    public string PerlPath { get; set; } = string.Empty;
    public string RPath { get; set; } = string.Empty;
}
