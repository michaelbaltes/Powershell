Add-Content -Path C:\Windows\Logs\migration-Reboot.log "***** Start Script *****"
$Computer = Get-WmiObject -Class Win32_ComputerSystem 
if ($computer.domain -eq "intra.phbern.ch")
{
    Add-Content -Path C:\Windows\Logs\migration-Reboot.log "Computer now in INTRA domain.... Starting check!"
    $command = "gpupdate.exe"
    $Parms = "/force /boot /Wait:0"
    $Prms = $Parms.Split(" ")
    Add-Content  -Path C:\Windows\Logs\migration-Reboot.log "Wait 30 seconds..."
    Start-Sleep -Seconds 30



    do
    {
     Add-Content  -Path C:\Windows\Logs\migration-Reboot.log "Working inside do loop...."
     Add-Content  -Path C:\Windows\Logs\migration-Reboot.log "Computer $($computer.domain) will be check for policy to force gpupdate now..."
     & "$Command" $Prms
    }
    Until((Get-WinEvent -LogName "Microsoft-Windows-GroupPolicy/operational" -MaxEvents 100 | ?{$_.ID -eq 8004} | select message).message -like "*INTRA\*")
    Add-Content  -Path C:\Windows\Logs\migration-Reboot.log "Policy like INTRA found..."
    Add-Content -Path C:\Windows\Logs\migration-Reboot.log ("Computer `"{0}.{1}`" is in this current domain: $($computer.domain) " -f $Computer.Name,$computer.domain)
    Add-Content -Path C:\Windows\Logs\migration-Reboot.log " **** End script ****"
}
else
{
Add-Content -Path C:\Windows\Logs\migration-Reboot.log "Computer in Domain $($computer.domain) , Migration not started jet!"
Add-Content -Path C:\Windows\Logs\migration-Reboot.log " **** End script ****"
}

