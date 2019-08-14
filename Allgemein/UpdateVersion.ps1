# Update Post Script for Applications

#region ~~~~~~~~~~~~~~ Variablen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# $Software = $args[0] # "DevolutionsInc_RemoteDesktopManager_2019.1.25.0_x64_DE_01"
$SoftwareTitle = $args[0] # Remote Desktop Manager Enterprise
$Version = $null  # read from local UpdateList
$Key = "HKLM:\SOFTWARE\PHBernApp\$Software"
$name1 = "UpdateDate"
$name2 = "UpdateVersion"
$logfile = $Software + "_update.txt"
$datum = get-date -Format dd.MM.yyyy 
$datum | Out-File -FilePath C:\windows\Logs\$logfile
$zahl = $null
$version = $null
$ScriptVersion = "0.4" | Out-File -FilePath C:\windows\Logs\$logfile -Append

$SWUpdate = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match $SoftwareTitle} | select Name, Version
$UpdKeyname = get-ChildItem -Path HKLM:\Software\PHBernapp | Where-Object {$_.Name -match ($softwareTitle.replace(" ",""))} | select name
$UpdKeyname = $UpdKeyname.Name.replace("HKEY_LOCAL_MACHINE", "HKLM:")
#endregion ~~~~~~ Variablen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#region ~~~~~~~~~~~~~~ Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Function Test-RegistryValue($key,$name)
{
     if(Get-Member -InputObject (Get-ItemProperty -Path $key) -Name $name) 
     {
          return $true
     }
     return $false
}
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#region ~~~~~~~~~~~~~~ Main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ((Test-RegistryValue $key $name1) -eq $false)
{
    "New entry for UpdateDate = $datum" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    New-ItemProperty -Path $UpdKeyname -Name UpdateDate -Value $(get-date -Format yyyyMMdd)  -PropertyType String
}
else {
    "Update entry Updatedate = $datum" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    Set-ItemProperty -Path $UpdKeyname -Name UpdateDate -Value $(get-date -Format yyyyMMdd) -Force
    
}



if ((Test-RegistryValue $key $name2) -eq $false)
{
    "New entry for UpdateVersion = $Version" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    New-ItemProperty -Path $UpdKeyname -Name UpdateVersion -Value $SWUpdate.Version  -PropertyType String
}
else {
    "Update entry UpdateVersion = $Version" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    Set-ItemProperty -Path $UpdKeyname -Name UpdateVersion -Value $SWUpdate.Version  -Force
}
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~