using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;

namespace Census.App.ViewModels;

/// <summary>
/// A node in the left "All runs" navigation tree. The root node has a null
/// <see cref="Run"/>; leaf nodes carry the run they select when clicked.
/// </summary>
public sealed partial class RunTreeNode : ObservableObject
{
    public RunTreeNode(string label, RunSummaryViewModel? run)
    {
        Label = label;
        Run = run;
    }

    public string Label { get; }
    public RunSummaryViewModel? Run { get; }
    public ObservableCollection<RunTreeNode> Children { get; } = [];

    [ObservableProperty]
    private bool _isExpanded = true;
}
