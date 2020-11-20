$time = Get-Date -Format 'yyyy-MM-dd_HH_mm_ss_ffff'
$Path = "$env:temp\report$time.xlsx"

Get-Process | 
 Export-Excel -Path $Path -WorksheetName Processes -ChartType PieExploded3D -IncludePivotChart -IncludePivotTable -Show -PivotRows Company -PivotData PM
