
$hash = @{}
$hash.Add("Erster", "Unknown")
$hash.Add("Zweiter", (Get-Date))
$hash.Dritter = 4
$hash['Vierter'] = 'fünf'
# klassische instantiierung:
New-Object PSObject -Property $hash
New-Object PSCustomObject -Property $hash
# geht (cheat)
[PSCustomObject]$hash
# geht nicht
[PSObject]$hash

