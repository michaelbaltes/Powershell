$Path = "$Home\Desktop\PowerShell ISE.lnk"
$Target = "powershell_ise.exe"
$Icon = "powershell_ise.exe,0"


if (-not $Icon.Contains(','))
{
    $Icon += ',0'
}

$obj = New-Object -ComObject WScript.Shell
$scut = $obj.CreateShortcut($path)
$scut.TargetPath = $Target
$scut.IconLocation = $Icon
$scut.WorkingDirectory = "\\192.168.0.1\Class"
$scut.Save() 

explorer /select,$Path