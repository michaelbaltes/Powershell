function Start-InNewThread
{
    param
    (
        [ScriptBlock]$Code,
        [Hashtable]$Parameters = @{}
    )
    $PowerShell = [PowerShell]::Create()
    $action = {
        $status = $event.SourceEventArgs.InvocationStateInfo.State
        if ($status -eq 'Completed')
        {
            try
            {
                $PowerShell = $event.Sender
                $PowerShell.Runspace.Close()
                $PowerShell.Dispose()
                Unregister-Event -SourceIdentifier $event.SourceIdentifier
            }
            catch
            {
                Write-Warning "$_"
            }
        }
    }
    $null = Register-ObjectEvent -InputObject $PowerShell -Action $action -EventName InvocationStateChanged
    $null = $PowerShell.AddScript($Code)
    foreach($key in $Parameters.Keys)
    {
        $null = $PowerShell.AddParameter($key, $Parameters.$key)
    }
    $handle = $PowerShell.BeginInvoke()
}
$xaml = @"
<Window
xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
MinWidth='300'
Width='600'
MinHeight='300'
Height = '300'>
<Grid Margin="5">
<Grid.RowDefinitions>
<RowDefinition Height="*"></RowDefinition>
<RowDefinition Height="Auto"></RowDefinition>
</Grid.RowDefinitions>
<ListView Name="View1">
<ListView.View>
<GridView>
<GridViewColumn Width="100" Header="KB" DisplayMemberBinding="{Binding HotfixID}"/>
<GridViewColumn Width="150" Header="Typ" DisplayMemberBinding="{Binding Description}"/>
<GridViewColumn Width="150" Header="Datum" DisplayMemberBinding="{Binding InstalledOn}"/>
<GridViewColumn Width="150" Header="Verantwortlich" DisplayMemberBinding="{Binding Installe
dBy}"/>
</GridView>
</ListView.View>
</ListView>
<StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="
Bottom">
<Button Name="butShow" Width="80" Height="30" Margin="5">Show</Button>
<Button Name="butOK" Width="80" Height="30" Margin="5">OK</Button>
</StackPanel>
</Grid>
</Window>
"@
$reader = [System.XML.XMLReader]::Create([System.IO.StringReader] $xaml)
$window = [System.Windows.Markup.XAMLReader]::Load($reader)
$buttonOK = $window.FindName('butOK')
$buttonShow = $window.FindName('butShow')
$code1 = {
    param($Fenster)
    # Hotfixes im Hintergrund-Thread abrufen ...
    [Console]::Beep(500,600)
    $hotfixes = Get-Hotfix
    [Console]::Beep(1500,600)
    # ... und dann im UI-Thread anwenden:
    $Fenster.Dispatcher.Invoke([Action]{
            $view = $Fenster.FindName('View1')
            $view.ItemsSource = @($hotfixes)
    },'Normal')
}
$code2 = { $window.Close() }
$buttonShow.add_Click({ Start-InNewThread -Code $code1 -Parameters @{Fenster=$window}})
$buttonOK.add_Click($code2)
$null = $window.ShowDialog()
