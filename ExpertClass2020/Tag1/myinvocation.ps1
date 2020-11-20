

$MyInvocation.MyCommand

$PSScriptRoot
$PSCommandPath

Set-PSBreakpoint -Variable psscriptroot -Mode Read -Action { if ([string]::IsNullOrEmpty($PSScriptRoot)) { $PSScriptRoot = 'c:\zumsel'; [Console]::Beep() }  }

Set-Variable -Name abc -Value server1 -Option Constant,AllScope
Get-Variable | Where-object  <# nur mit Schreibschutz #>
