
# schlecht, da es eine "echte" PowerShell-Variante gibt:
[DateTime]::Now
Get-Date 

# fremdartig:
[void](New-Item -Path c:\testordner -ItemType directory)
# optimal:
$null = New-Item -Path c:\testordner2 -ItemType directory
# langsam:
New-Item -Path c:\testordner -ItemType directory | Out-Null