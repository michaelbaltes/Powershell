# download
$a = Get-Process
$a.Name 

# streaming
Get-Process | Select-Object -ExpandProperty Name
