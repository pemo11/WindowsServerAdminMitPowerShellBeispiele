<#
  .Synopsis
  Template für ein WPF-Fenster
#>

$AppName = "WPFApp"
$WindowTitle = "WPF-App"
$Label1Content = "Label1"
$Button1Content = "OK"

$WindowXaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="$WindowTitle"
    FontSize = "24"
    Height="400"
    Width="600"
    >
    <DockPanel
        HorizontalAlignment = "Center"
        Margin="4,4,4,4"
        Background = "Lavender"
        LastChildFill="false"
    >
    <Label
        x:Name="Label1"
        Background = "HotPink"
        HorizontalContentAlignment = "Center"
        DockPanel.Dock = "Top"
        Content="$Label1Content"
        Height="40"
        Width="400"
        Margin="4,12,0,0"
    />
    <TextBox
        x:Name="TextBox1"
        Background = "Cyan"
        HorizontalContentAlignment = "Center"
        DockPanel.Dock = "Top"
        Text = "&lt;Irgendetwas eingeben&gt;"
        Height = "40"
        Width = "400"
        Margin = "4,12,0,0"
        />
    <Button
        x:Name="Button1"
        Content="$Button1Content"
        DockPanel.Dock = "Bottom"
        Height="40"
        Width="200"
        Margin="4,4,0,12"
        />   
  </DockPanel>
</Window> 
"@

# Drei Assembly-Dateien werden für WPF benötigt
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# Fenster aus dem XAML-Code anlegen
$Win = [System.Windows.Markup.XamlReader]::Parse($WindowXaml)

# Die FindName-Methode holt ein WPF-Control anhand seines Namens
$Button1 = $Win.FindName("Button1")
$Textbox1 = $Win.FindName("TextBox1")
$Textbox1Content = $Textbox1.Text
       
# Das Scriptblock-Element wird dem Click-Event-Handler des Button angehängt
$Button1SB = {
    [System.Windows.MessageBox]::Show("Vielen Dank - das Eingabefeld enthaelt: {0}" -f $Textbox1Content, $AppName)
    $Win.Close()
} 

$Button1.add_Click($Button1SB)

# Fenster als modales Dialogfenster anzeigen
$Win.ShowDialog() 
