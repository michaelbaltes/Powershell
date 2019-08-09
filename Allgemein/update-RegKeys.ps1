# Update Post Script for Applications

#region ~~~~~~~~~~~~~~ Variablen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Software = $args[0] # "DevolutionsInc_RemoteDesktopManager_2019.1.25.0_x64_DE_01"
$SoftwareTitle = $args[1] # Remote Desktop Manager Enterprise
$Version = $null  # read from local UpdateList
$Key = "HKLM:\SOFTWARE\PHBernApp\$Software"
$name1 = "UpdateDate"
$name2 = "UpdateVersion"
$datum = get-date -Format dd.MM.yyyy
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#region ~~~~~~~~~~~~~~ Get local Update information to set up registry ~~~~~~~~~~~~~~~~~~~

$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()

$historyCount = $Searcher.GetTotalHistoryCount()

$update=  $Searcher.QueryHistory(0, $historyCount) | Where-Object {$_.Title -like "$SoftwareTitle*"} | select title, Date
if ($update.GetType().BaseType.name -eq "Array")
{
    foreach($i in $update)
        {
            $zahl += 1
            if ((get-date -date $i.date -Format dd.MM.yyyy) -eq $datum -and $zahl -eq 1)
            {
                $arUpdate = $i.title.Split("$SoftwareTitle")
                $Version = $arUpdate[$arUpdate.LongLength -1]
                write-host $Version
            }

        }
}
else {
    $arUpdate = $update.title.Split("$SoftwareTitle")
    $Version = $arUpdate[$arUpdate.LongLength -1]
    write-host $Version        
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
    New-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateDate -Value $(get-date -Format yyyyMMdd)  -PropertyType String
}
else {
    Set-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateDate -Value $(get-date -Format yyyyMMdd) -Force
    
}



if ((Test-RegistryValue $key $name2) -eq $false)
{
    New-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateVersion -Value $Version  -PropertyType String
}
else {
    Set-ItemProperty -Path HKLM:\SOFTWARE\PHBernApp\$Software -Name UpdateVersion -Value $Version  -Force
}
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~