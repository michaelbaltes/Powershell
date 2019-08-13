# Update Post Script for Applications

#region ~~~~~~~~~~~~~~ Variablen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Software = $args[0] # "DevolutionsInc_RemoteDesktopManager_2019.1.25.0_x64_DE_01"
$SoftwareTitle = $args[1] # Remote Desktop Manager Enterprise
$Version = $null  # read from local UpdateList
$Key = "HKLM:\SOFTWARE\PHBernApp\$Software"
$name1 = "UpdateDate"
$name2 = "UpdateVersion"
$logfile = $Software + "_update.txt"
$datum = get-date -Format dd.MM.yyyy 
$datum | Out-File -FilePath C:\windows\Logs\$logfile
$zahl = $null
$version = $null

$ScrippVersion = "0.3" | Out-File -FilePath C:\windows\Logs\$logfile -Append
Start-Sleep -Seconds 10

#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#region ~~~~~~~~~~~~~~ Get local Update information to set up registry ~~~~~~~~~~~~~~~~~~~

$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()

$historyCount = $Searcher.GetTotalHistoryCount()

$update=  $Searcher.QueryHistory(0, $historyCount) | Where-Object {$_.Title -like "$SoftwareTitle*"} | select title, Date
$update | Out-File -FilePath C:\windows\Logs\$logfile -Append
if ($update.GetType().BaseType.name -eq "Array")
{
    foreach($i in $update)
        {
            $zahl += 1 
            $i | Out-File -FilePath C:\windows\Logs\$logfile -Append
            $zahl | Out-File -FilePath C:\windows\Logs\$logfile -Append
            if ((get-date -date $i.date -Format dd.MM.yyyy) -eq $datum -and $zahl -eq 1)
            {
                $arUpdate = $i.Title.split("(\d)") 
                $arUpdate = $arUpdate.split(" ")
                $version = $arupdate[$arUpdate.Length -1]
                "Set Version to Registry : " + $Version | Out-File -FilePath C:\windows\Logs\$logfile -Append 
            }
                #$Version = $arUpdate[$b -1]
                "No Version set to Registry, because no match was found!" | Out-File -FilePath C:\windows\Logs\$logfile -Append
         }
}

else {
    "No array" | Out-File -FilePath C:\windows\Logs\$logfile -Append
     $arUpdate = $i.Title.split("(\d)") 
     $arUpdate = $arUpdate.split(" ")
     $version = $arupdate[$arUpdate.Length -1]
     $Version | Out-File -FilePath C:\windows\Logs\$logfile -Append        
}
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#region ~~~~~~~~~~~~~~ Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Function Test-RegistryValue($key,$name)
{
     if(Get-Member -InputObject (Get-ItemProperty -Path $key) -Name $name) 
     {
          return $true
     }
     return $false
}
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#region ~~~~~~~~~~~~~~ Main ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ((Test-RegistryValue $key $name1) -eq $false)
{
    "New entry for UpdateDate = $datum" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    New-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateDate -Value $(get-date -Format yyyyMMdd)  -PropertyType String
}
else {
    "Update entry Updatedate = $datum" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    Set-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateDate -Value $(get-date -Format yyyyMMdd) -Force
    
}



if ((Test-RegistryValue $key $name2) -eq $false)
{
    "New entry for UpdateVersion = $Version" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    New-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateVersion -Value $Version  -PropertyType String
}
else {
    "Update entry UpdateVersion = $Version" | Out-File -FilePath C:\windows\Logs\$logfile -Append
    Set-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateVersion -Value $Version  -Force
}
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~