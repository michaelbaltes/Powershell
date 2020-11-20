
<#
set a = CreateObject('Scripting.FileSystemObject')
#>

$a = New-Object -ComObject Scripting.FileSystemObject

$b = New-Object -ComObject WScript.Shell
$scut = $b.CreateShortcut("$env:temp\link.lnk")
$scut.TargetPath = 'powershell.exe'
$scut.Arguments = ' -noprofile -command Get-Service | Out-GridView -pass | Stop-Service -whatif'
$scut.Save()

