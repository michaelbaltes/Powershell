
Start-Transcript -Path "$PSScriptRoot\meinlog.txt" -Append
($a = Get-Service)
$a | Stop-Service -WhatIf
Stop-Transcript

notepad "$PSScriptRoot\meinlog.txt" 