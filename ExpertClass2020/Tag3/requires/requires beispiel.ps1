#requires -Version 3.0 -Modules NetTCPIP, PrintManagement


function LoadModules($Path)
{
    $requires = Get-Content -Path $Path | Select-Object -First 1
    if ($requires -like '#requires*')
    {
        ($requires -split '-Modules')[-1] -split ',' |
          ForEach-Object {
            Import-Module -Name $_.Trim() -Verbose
          }
    }
}

LoadModules -Path $PSCommandPath
return
Get-NetIPAddress
Get-Printer
dir c:\windows -file 