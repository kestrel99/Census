using Avalonia.Controls;
using Census.App.ViewModels;

namespace Census.App.Views;

public partial class MainWindow : Window
{
    public MainWindow() => InitializeComponent();

    // Push the grid's multi-selection to the view model for the Compare action.
    private void OnRunSelectionChanged(object? sender, SelectionChangedEventArgs e)
    {
        if (DataContext is MainWindowViewModel vm && sender is DataGrid grid)
            vm.SetCompareSelection(grid.SelectedItems);
    }
}
