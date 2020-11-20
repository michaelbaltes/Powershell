$Path = "$env:temp\PowerShell ISE.lnk"
$Target = "powershell_ise.exe"
$Icon = "$env:windir\system32\shell32.dll,4"


if (-not $Icon.Contains(','))
{
    $Icon += ',0'
}

$obj = New-Object -ComObject WScript.Shell
$scut = $obj.CreateShortcut($path)
$scut.TargetPath = $Target
$scut.IconLocation = $Icon
$scut.WorkingDirectory = "c:\"
$scut.Save() 

explorer /select,$Path