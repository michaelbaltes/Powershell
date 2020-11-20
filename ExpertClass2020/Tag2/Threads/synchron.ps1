


[System.Management.Automation.PowerShell]$ps = [System.Management.Automation.PowerShell]::Create()
$null = $ps.AddScript('Get-Variable')
$resultate = $ps.Invoke()
$resultate

