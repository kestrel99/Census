using Avalonia.Controls;
using Avalonia.Data;
using Census.App.ViewModels;

namespace Census.App.Views;

public partial class CompareWindow : Window
{
    public CompareWindow() => InitializeComponent();

    public CompareWindow(CompareViewModel vm) : this()
    {
        DataContext = vm;

        // First column: the parameter/metric label.
        CompareGrid.Columns.Add(new DataGridTextColumn
        {
            Header = "Parameter",
            Binding = new Binding(nameof(CompareRowViewModel.Label)),
            Width = new DataGridLength(170),
        });

        // One column per run, bound to the matching index in each row's Values list.
        for (var i = 0; i < vm.RunHeaders.Count; i++)
        {
            CompareGrid.Columns.Add(new DataGridTextColumn
            {
                Header = vm.RunHeaders[i],
                Binding = new Binding($"Values[{i}]"),
                Width = new DataGridLength(110),
            });
        }
    }
}
