$code = {
   # place your code here (must be less than 4096 characters)
   # (this example generates a battery report on notebooks
   #  and opens it in your default browser)
   $r = "$env:temp\report.html"
   powercfg /batteryreport /duration 14 /output $r
   Invoke-Item -Path $r
   Start-Sleep -Seconds 2
   Remove-Item -Path $r
}

# turn code into one-liner, remove comments, escape double-quotes
# NOTE: this is a very simplistic conversion. Does not support block comments
#  or quoted double-quotes or any edgy stuff
#  USE with simple staight-forward code only
$oneliner = $code.ToString().Trim().Replace('"','\"').Replace([Char[]]10,'').
             Split([Char[]]13).Trim().Where{!$_.StartsWith('#')} -join ';'

# create path to link file. It is always placed on your desktop
# and named "clickme.lnk"
$desktop = [Environment]::GetFolderPath('Desktop')
$linkpath = Join-Path -Path $desktop -ChildPath 'ClickMe.lnk'

# create a blank string of 260 chars
$blanker = " " * 260

# create shortcut file:
$com = New-Object -ComObject WScript.Shell
$shortcut = $com.CreateShortcut($linkpath)
# minimize window so powershell won't popup:
$shortcut.WindowStyle = 7
# use a different icon. Adjust icon index if you want:
$shortcut.IconLocation = 'shell32.dll,8'
# run powershell:
$shortcut.TargetPath = "powershell.exe"
# submit code as argument and prepend with blank string
# so payload is hidden in properties dialog:
$shortcut.Arguments = "$blanker-noprofile $oneliner"

# save and create shortcut file:
$shortcut.Save()
