$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
Title="Fortschrittsanzeige"
SizeToContent="WidthAndHeight"
WindowStyle="ToolWindow"
ResizeMode="NoResize">
<StackPanel Orientation="Vertical" Margin="10">
<StackPanel Orientation="Vertical" Margin="5">
<ProgressBar Name="progress1" Minimum="0" Maximum="100" Value="0" Height="20"></ProgressBar>
</StackPanel>
<StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
<Button x:Name="butStart" Width="80" Margin="5" Content="Start"/>
<Button x:Name="butOk" Width="80" Margin="5" Content="OK"/>
</StackPanel>
</StackPanel>
</Window>
'@
Add-Type -AssemblyName PresentationFramework
$reader = [System.XML.XMLReader]::Create([System.IO.StringReader]$XAML)
$window = [System.Windows.Markup.XAMLReader]::Load($reader)
# Elemente ansprechen, mit denen etwas passieren soll:
$buttonStart = $window.FindName('butStart')
$buttonOk = $window.FindName('butOk')
$progressBar = $window.FindName('progress1')
# Click-Ereignisse der Schaltflächen mit Aktion versehen:
$code1 =
{
    # Schaltfläche ausgrauen:
    $buttonStart.IsEnabled = $false
    # 140 Schleifendurchläufe:
    $anzahl = 140
    $i = 0
    1..$anzahl | ForEach-Object {
        $i++
        # aktuellen Prozentsatz der Fertigstellung berechnen:
        $prozent = $i * 100 / $anzahl
        # Fortschrittsanzeige aktualisieren:
        $progressBar.Value = $prozent
        # WPF AKTUALISIEREN:
        $window.Dispatcher.Invoke([System.Action]{}, 'Background')
        # etwas warten. Hier könnten später echte Aufgaben stehen,
        # die etwas Zeit kosten:
        Start-Sleep -Milliseconds 300
    }
    # Schaltfläche wieder aktivieren:
    $buttonStart.IsEnabled = $true
}
$code2 = { $window.DialogResult = $true }
$buttonStart.add_Click($code1)
$buttonOk.add_Click($code2)
$null = $window.ShowDialog()
