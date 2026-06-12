using Avalonia;
using Avalonia.Controls;
using Avalonia.Input;
using Avalonia.VisualTree;
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

    // Right-click should target the row under the pointer. If it is not already part of the
    // current multi-selection, select just that row before the context menu opens.
    private void OnRunGridPointerPressed(object? sender, PointerPressedEventArgs e)
    {
        if (!e.GetCurrentPoint(sender as Visual).Properties.IsRightButtonPressed)
            return;

        var visual = e.Source as Visual;
        while (visual is not null and not DataGridRow)
            visual = visual.GetVisualParent();

        if (visual is DataGridRow { DataContext: RunSummaryViewModel row }
            && (RunGrid.SelectedItems is null || !RunGrid.SelectedItems.Contains(row)))
        {
            RunGrid.SelectedItem = row;
        }
    }
}
