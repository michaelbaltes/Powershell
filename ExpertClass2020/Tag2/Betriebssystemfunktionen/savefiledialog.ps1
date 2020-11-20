

Add-Type -AssemblyName PresentationFramework
$dialog = [Microsoft.Win32.SaveFileDialog]::new()
$dialog.InitialDirectory = "c:\"
$dialog.Title = 'Wo soll das Log gespeichert werden?'
$dialog.Filter = 'Alles|*.*|Logs|*.log'

if($dialog.ShowDialog())
{
    $dialog.FileName
}
else
{
    Write-Warning "Abbruch"
}

