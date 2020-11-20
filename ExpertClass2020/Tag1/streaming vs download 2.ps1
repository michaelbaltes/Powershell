# download
$a = Get-ChildItem -Path c:\windows -Recurse -Filter *.log
$a.Name 

# streaming
Get-ChildItem -Path c:\windows -Recurse -Filter *.log | Select-Object -ExpandProperty Name


$a | Select-Object -ExpandProperty Name


Get-Date | Out-GridView
$ergebnis = Get-Date
Get-Date

$ergebnis