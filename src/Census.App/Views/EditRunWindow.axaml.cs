using Avalonia.Controls;
using Avalonia.Interactivity;

namespace Census.App.Views;

public partial class EditRunWindow : Window
{
    public EditRunWindow() => InitializeComponent();

    private void OnSave(object? sender, RoutedEventArgs e) => Close(true);

    private void OnCancel(object? sender, RoutedEventArgs e) => Close(false);
}
