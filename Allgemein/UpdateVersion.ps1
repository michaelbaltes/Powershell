# Update Post Script for Applications

#region ~~~~~~~~~~~~~~ Variablen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# $Software = $args[0] # "DevolutionsInc_RemoteDesktopManager_2019.1.25.0_x64_DE_01"
$SoftwareTitle = $args[0] # Remote Desktop Manager Enterprise
$Version = $null  # read from local UpdateList
$Key = "HKLM:\SOFTWARE\PHBernApp\$Software"
$name1 = "UpdateDate"
$name2 = "UpdateVersion"
$logfile = $softwareTitle.replace(" ","") + "_update.txt"
$datum = get-date -Format dd.MM.yyyy 
$datum | Out-File -FilePath C:\windows\Logs\$logfile
$zahl = $null
$version = $null
$ScriptVersion = "0.91" | Out-File -FilePath C:\windows\Logs\$logfile -Append

#Update KeyName for PHBern
try{
$UpdKeyname = get-ChildItem -Path HKLM:\Software\PHBernapp | Where-Object {$_.Name -match ($softwareTitle.replace(" ",""))} | select name
$UpdKeyname = $UpdKeyname.Name.replace("HKEY_LOCAL_MACHINE", "HKLM:")
}
catch
{
"$SoftwareTitle is not the corrrect Name!" | Out-File -FilePath C:\windows\Logs\$logfile -Append
}

# Get installed SoftwareVersion
try{
$x64SW = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | % {Get-ItemProperty $_.PsPath} | ? {$_.DisplayName -match $SoftwareTitle} | select Displayname, DisplayVersion
$x86SW = Get-ChildItem HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | % {Get-ItemProperty $_.PsPath} | ? {$_.DisplayName -match $SoftwareTitle} | select Displayname, DisplayVersion
}
catch
{
"No matching Product found!!" | Out-File -FilePath C:\windows\Logs\$logfile -Append
}
if($x64SW -eq $null -and $x86SW -ne $null)
    {
    $SWUpdate = $x86SW
    }
else
    {
    $SWUpdate = $x64SW
    }
if ($SWUpdate -eq $null)
    {
    "ERROR: No Version found for Product: $SoftwareTitle" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    }
else
{
    #endregion ~~~~~~ Variablen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    #region ~~~~~~~~~~~~~~ Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Function Test-RegistryValue($name)
    {
         if(Get-Member -InputObject (Get-ItemProperty -Path $UpdKeyname) -Name $name) 
         {
              return $true
         }
         return $false
    }
    #endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    #region ~~~~~~~~~~~~~~ Main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "Product information will be update for $($SWUpdate.DisplayName) now!" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    if ((Test-RegistryValue $name1) -eq $false)
    {
        "New entry for UpdateDate = $datum" | Out-File -FilePath C:\windows\Logs\$logfile -Append
        New-ItemProperty -Path $UpdKeyname -Name UpdateDate -Value $(get-date -Format yyyyMMdd)  -PropertyType String
    }
    else {
        "Update entry Updatedate = $datum" | Out-File -FilePath C:\windows\Logs\$logfile -Append
        Set-ItemProperty -Path $UpdKeyname -Name UpdateDate -Value $(get-date -Format yyyyMMdd) -Force
    
    }



    if ((Test-RegistryValue $name2) -eq $false)
    {
        "New entry for UpdateVersion = $($SWUpdate.DisplayVersion)" | Out-File -FilePath C:\windows\Logs\$logfile -Append
        New-ItemProperty -Path $UpdKeyname -Name UpdateVersion -Value $SWUpdate.DisplayVersion  -PropertyType String
    }
    else {
        "Update entry UpdateVersion = $($SWUpdate.DisplayVersion)" | Out-File -FilePath C:\windows\Logs\$logfile -Append
        Set-ItemProperty -Path $UpdKeyname -Name UpdateVersion -Value $SWUpdate.DisplayVersion  -Force
    }
    #endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}