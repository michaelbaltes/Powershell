
#install-module -name scriptblocklogginganalyzer -Scope CurrentUser -Force

Enable-SBL
Set-SBLLogSize -MaxSizeMB 100
Get-SBLEvent | Out-GridView
Get-SBLEvent | Where-Object Name -like *.exe | Out-GridView