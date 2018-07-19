######################################################################## 
# Setting variables you have to fill in for your environment 
######################################################################## 
$logfile = "C:\ADMT Files\logs\GroupChangeFinder"
$dayschange_sinceGroupChange = 120 # fill in the number of hours since the user change his password. For example: 23 (When you run the script on 23:00h)
# modifyTimeStamp

######################################################################## 
# Create LogFile 
######################################################################## 
$logdate = Get-Date -format yyyyMMdd 
$logfile = $logfile + "_$logdate.log"
Add-Content $logfile ("************* Starting Script ************* {0:yyyyMMdd}" -f (get-date))
Add-Content $logfile "samaccountname, WhenChanged, today, hoursdiff" 

$GlobalGroups = @()
$LocalGroups = @()

Get-ADGroup -Server srv-dc-004 -Filter * -Properties * -SearchBase "OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local" | select SamAccountName,WhenChanged,extensionAttribute1 |  % { 
      $samaccountname = $_.SamAccountName 
      $today = Get-Date 
 
      # Get the timedifference between last password change and the current date/time 
      $timediff = New-TimeSpan $_.WhenChanged $(Get-Date)  
   
      # Convert to difference in hours 
      $daysdiff = $timediff.Totaldays 

      # Wenn kleiner oder gleich als 60 Tage (also alles bis vor 2 Monaten)
      if ($daysdiff -le $dayschange_sinceGroupChange -and $_.extensionAttribute1 -like "G*") 
        {
        write-host -ForegroundColor DarkYellow "Globale Gruppe muss migriert werden:" $_.SamAccountName $_.WhenChanged
        Add-Content $logfile "Work on: $samaccountname"
        Add-Content $logfile "Replace extensionAttribute1 from $($_.extensionAttribute1) to: $($_.extensionAttribute1 -replace "_" , "-")"
        Set-adgroup -server srv-dc-004 $samaccountname -Replace @{extensionAttribute1=$($_.extensionAttribute1 -replace "_" , "-")}
        $object = New-Object psobject
        $object | Add-Member NoteProperty SourceName ($samaccountname)
        $object | Add-Member NoteProperty TargetRDN ("CN=" + $($_.extensionAttribute1 -replace "_" , "-"))
        $object | Add-Member NoteProperty TargetUPN ($($_.extensionAttribute1 -replace "_" , "-"))
        $GlobalGroups += $object
        }
       elseif ($daysdiff -le $dayschange_sinceGroupChange -and $_.extensionAttribute1 -like "L*")
        {
        write-host -ForegroundColor DarkYellow "Lokale Gruppe muss migriert werden:" $_.SamAccountName $_.WhenChanged
        Add-Content $logfile "Work on: $samaccountname"
        Add-Content $logfile "Replace extensionAttribute1 from $($_.extensionAttribute1) to: $($_.extensionAttribute1 -replace "_" , "-")"
        Set-adgroup -server srv-dc-004 $samaccountname -Replace @{extensionAttribute1=$($_.extensionAttribute1 -replace "_" , "-")}
        $object = New-Object psobject
        $object | Add-Member NoteProperty SourceName ($samaccountname)
        $object | Add-Member NoteProperty TargetRDN ("CN=" + $($_.extensionAttribute1 -replace "_" , "-"))
        $object | Add-Member NoteProperty TargetUPN ($($_.extensionAttribute1 -replace "_" , "-"))
        $LocalGroups += $object
        } 
    }

   $GlobalGroups | export-csv -Path "C:\ADMT Files\GroupFinder\global_$logdate.csv" -NoTypeInformation -Encoding UTF8
   $localGroups | export-csv -Path "C:\ADMT Files\GroupFinder\local_$logdate.csv" -NoTypeInformation -Encoding UTF8