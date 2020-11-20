

Install-Module -Name ImportExcel -Scope CurrentUser -Force

$Path = "$env:temp\report.xlsx"
Get-Service | Select-Object -Property Name, Status | Export-Excel -Path $Path -ClearSheet -WorksheetName Dienste -AutoFilter -AutoSize -FreezeTopRow -
Get-Process | Select-Object -Property Name, Status | Export-Excel -Path $Path -ClearSheet -WorksheetName Prozesse -AutoFilter -AutoSize -FreezeTopRow -Show


