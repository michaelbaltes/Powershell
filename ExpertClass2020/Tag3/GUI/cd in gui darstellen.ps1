
$xaml = @'
<Window
 xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
 xmlns:x='http://schemas.microsoft.com/winfx/2006/xaml'
 Title='Process Killer' SizeToContent='WidthAndHeight'>
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="40" />
                <RowDefinition Height="400" />
                <RowDefinition Height="28" />
            </Grid.RowDefinitions>
            <TextBlock Margin="5">Select Processes to terminate:</TextBlock>
            <ListView Grid.Row="1" Name="View1">
                <ListView.View>
                    <GridView>
                        <GridViewColumn Width="200" Header="Album" DisplayMemberBinding="{Binding Title}"/>
                        <GridViewColumn Width="400" Header="Künstler" DisplayMemberBinding="{Binding Artist}"/>
                        <GridViewColumn Width="150" Header="Land" DisplayMemberBinding="{Binding Country}"/>
                        <GridViewColumn Width="100" Header="Erscheinungsjahr" DisplayMemberBinding="{Binding Year}"/>
                    </GridView>
                </ListView.View>
            </ListView>
            <StackPanel Orientation="Horizontal" Grid.Row="2" HorizontalAlignment="Right">
                <Button Name='KillProcess' HorizontalAlignment="Right" MinWidth="80" Margin="3" Content="Kill Process" />
                <Button Name='CloseWindow' HorizontalAlignment="Right" MinWidth="80" Margin="3" Content="Close" />
            </StackPanel>
        </Grid>
</Window>
'@
function Convert-XAMLtoWindow
{
  param
  (
    [Parameter(Mandatory=$true)]
    [string]
    $XAML
  )
    
  Add-Type -AssemblyName PresentationFramework
    
  $reader = [XML.XMLReader]::Create([IO.StringReader]$XAML)
  $result = [Windows.Markup.XAMLReader]::Load($reader)
  $reader.Close()
  $reader = [XML.XMLReader]::Create([IO.StringReader]$XAML)
  while ($reader.Read())
  {
    $name=$reader.GetAttribute('Name')
    if (!$name) { $name=$reader.GetAttribute('x:Name') }
    if($name)
    {$result | Add-Member NoteProperty -Name $name -Value $result.FindName($name) -Force}
  }
  $reader.Close()
  $result
}


function Show-WPFWindow
{
  param
  (
    [Parameter(Mandatory)]
    [Windows.Window]
    $Window
  )
    
  $result = $null
  $null = $window.Dispatcher.InvokeAsync{
    $result = $window.ShowDialog()
    Set-Variable -Name result -Value $result -Scope 1
  }.Wait()
  $result
}

$window = Convert-XAMLtoWindow -XAML $xaml
$window.KillProcess.add_Click{
  # remove -whatif to actually kill processes:
  $window.View1.SelectedItems | Stop-Process -WhatIf
  $window.View1.ItemsSource = @(Get-Process | Where-Object { $_.MainWindowTitle })
}
$window.CloseWindow.add_Click{
  $window.DialogResult = $false
}

$Path = "C:\XpertClass\ExpertClass2020\Tag3\GUI\demo.xml"

#[xml]$xml = Get-Content -Path $Path -Raw


$xml = [xml]::new()
$xml.Load($Path)
$daten = $xml.CATALOG.CD | Select-object * 
$daten = [System.Management.Automation.PSCustomObject]@{1 = 'Test'}
$window.View1.ItemsSource = @($daten)

$null = Show-WPFWindow -Window $window

