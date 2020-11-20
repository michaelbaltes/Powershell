$ich = Get-Process -id $pid
$hülle = $ich.PSObject
$hülle.Properties  | Where-Object Value -ne $null | Select-Object -Property Name, Value