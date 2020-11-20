$hash['key'] = 123243
$hash
New-Object PSObject -Property $hash
New-Object PSCustomObject -Property $hash

$hash = @{}
$hash.Add("Erster", "Unknown")
$hash.Add("Zweiter", (Get-Date))
$hash.Dritter = 4
$hash['Vierter'] = 'fünf'
# klassische instantiierung:
New-Object PSObject -Property $hash
New-Object PSCustomObject -Property $hash
$hash = [Ordered]@{}
$hash.Add("Erster", "Unknown")
$hash.Add("Zweiter", (Get-Date))
$hash.Dritter = 4
$hash['Vierter'] = 'fünf'
# klassische instantiierung:
New-Object PSObject -Property $hash
New-Object PSCustomObject -Property $hash
[PSObject]$hash
[PSCustomObject]$hash
[PSObject]$hash
$a = get-process
$a[0] | Get-Member
$a[0].CPU
$a
$a | select -First 2
explorer $pshome
$a | Select-Object -Property * | Get-Member
Get-Process -id $pid
$ich = Get-Process -id $pid
$ich.GetType().FullName
$ich.PSTypeNames
$ich.PSTypeNames.Clear()
$ich.PSTypeNames
$ich.handles
$ich.PSTypeNames.Add('System.DateTime')
$ich.PSTypeNames
$ich.DateTime
$ich = Get-Process -id $pid
$ich.pstypenames
$hülle = $ich.PSObject
$hülle.Properties
$hülle.Properties.Name
$hülle.Properties
$hülle.Properties | Where-Object IsSettable | Select-Object Name, TypeOfValue
$hülle.Properties | Where-Object IsSettable | Select-Object Name, TypeNameOfValue
