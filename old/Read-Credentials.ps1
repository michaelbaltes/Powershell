if (!(Test-Path C:\temp)){New-Item -Path "c:\" -Name "temp" -ItemType "Directory"}
$cmdkey = "C:\Windows\System32\cmdkey.exe"
$para1 = "/List:MS.Out*"
$para2 = "/List:Webmail*"
$creds = &$cmdkey $para1
$creds | Out-File -FilePath C:\temp\$env:USERNAME-$(get-date -Format yyyyMMdd-hhmm).txt -Append
$creds = $null
$creds = &$cmdkey $para2
$creds | Out-File -FilePath C:\temp\$env:USERNAME-$(get-date -Format yyyyMMdd-hhmm).txt -Append