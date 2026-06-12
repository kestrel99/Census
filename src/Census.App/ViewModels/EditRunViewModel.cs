using Census.Domain;
using CommunityToolkit.Mvvm.ComponentModel;

namespace Census.App.ViewModels;

/// <summary>Editable run metadata shown in the Edit dialog: parent run and comment.</summary>
public sealed partial class EditRunViewModel : ObservableObject
{
    public EditRunViewModel(Run run, IEnumerable<string> otherRunNumbers)
    {
        RunNo = run.RunNo;
        Comment = run.Comment ?? string.Empty;
        ParentNo = run.ParentNo ?? string.Empty;

        // "" lets the user clear the parent; the rest are the other runs in the project.
        ParentOptions = new[] { string.Empty }
            .Concat(otherRunNumbers)
            .ToList();
    }

    public string RunNo { get; }
    public IReadOnlyList<string> ParentOptions { get; }

    [ObservableProperty]
    private string _parentNo = string.Empty;

    [ObservableProperty]
    private string _comment = string.Empty;
}
