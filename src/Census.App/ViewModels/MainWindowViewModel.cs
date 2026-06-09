using CommunityToolkit.Mvvm.ComponentModel;

namespace Census.App.ViewModels;

public partial class MainWindowViewModel : ObservableObject
{
    [ObservableProperty]
    private string _greeting = "Census — Avalonia scaffold ready.";
}
