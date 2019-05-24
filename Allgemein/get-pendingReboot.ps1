function Test-PendingReboot
{
    foreach ($servername in $servers)
    {
        invoke-command -ComputerName $servername -ScriptBlock {
        if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
        if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
        if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
        try { 
        $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
        $status = $util.DetermineIfRebootPending()
        if(($status -ne $null) -and $status.RebootPending){
            return "Server $env:COMPUTERNAME nedds to be restart!"
        }
        }catch{}
        
        return "$env:COMPUTERNAME OK!"
    }
}
}

$servers = Get-Content -Path c:\_mba\data\server.txt

Test-PendingReboot