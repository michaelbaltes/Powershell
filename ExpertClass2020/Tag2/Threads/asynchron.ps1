


[System.Management.Automation.PowerShell]$ps = [System.Management.Automation.PowerShell]::Create()
$null = $ps.AddScript('Get-Hotfix; Start-Sleep -sec 5')
$handle = $ps.BeginInvoke()

do
{
    Write-Host "." -NoNewline
    Start-Sleep -Milliseconds 300
} until ($handle.IsCompleted)

$result = $ps.EndInvoke($handle)
$ps.Runspace.Close()
$ps.Dispose()
$result





