######################################################################## 
# Setting variables you have to fill in for your environment 
######################################################################## 
$logfile = "C:\ADMT Files\logs\PW-Changer" 
$DN_OU_Path = #fill in your distinguishedName OU path where the effected users exist. For example: CN=Users,DC=Contoso,DC=local 
$hourschange_sincePwdChange = 24 # fill in the number of hours since the user change his password. For example: 23 (When you run the script on 23:00h) 
$staffUserVerwaltung = @() # Content of csv Files for migration
$staffUserCampus = @() # Content of csv Files for migration
$studentUserCampus = @() # Content of csv Files for migration
$optCampusStudent = "C:\ADMT Files\option\optCampusStudent.txt"# option file used for migration from PHBECAMPUS to INTRA
$optCampusStaff = "C:\ADMT Files\option\optCampusStaff.txt"# option file used for migration from PHBECAMPUS to INTRA
$optVerwaltungStaff = "C:\ADMT Files\option\optVerwaltungStaff.txt" # option file used for migration from VERWALTUNG to INTRA
$csvOutputCampusStaff = "C:\ADMT Files\PWChanger\PW-staff-Campus.csv" # Export User to csv file
$csvOutputCampusStudent = "C:\ADMT Files\PWChanger\PW-student-Campus.csv" # Export User to csv file
$csvOutputVerwaltungStaff = "C:\ADMT Files\PWChanger\PW-staff-Verwaltung.csv" # Export User to csv file
$Command = "c:\Windows\ADMT\admt.exe" 
 
######################################################################## 
# Create LogFile 
######################################################################## 
$logdate = Get-Date -format yyyyMMdd 
$logfile = $logfile + "_$logdate.log"
Add-Content $logfile ("************* Starting Script ************* {0:yyyyMMdd}" -f (get-date))
Add-Content $logfile "samaccountname, lastchange, today, hoursdiff" 

################################################################################################################################################ 
# VERWALTUNG
################################################################################################################################################  
 
$domain = "Verwaltung" 
######################################################################## 
# Set scope for effected users --- only user who have extensionAttribute1 set.
######################################################################## 
Get-ADUser -server srv-dc-004 -Filter * -SearchBase "OU=Users,OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local" -SearchScope Subtree -Properties Name,pwdLastSet ,extensionAttribute1 | ? {$_.extensionAttribute1 -ne $null} | select SamAccountName,pwdLastSet | 
 
 
######################################################################## 
# Start the real thing 
######################################################################## 
ForEach-Object { 
  $samaccountname = $_.SamAccountName 
  $today = Get-Date 
   
  # Convert the Date in a good Format 
  $lastchange = [datetime]::FromFileTime($_.pwdlastset[0]) # Convert the Date in a good Format 
 
  # Get the timedifference between last password change and the current date/time 
  $timediff = New-TimeSpan $lastchange $(Get-Date) 
   
  # Convert to difference in hours 
  $hoursdiff = $timediff.TotalHours 
 
  if ($hoursdiff -le $hourschange_sincePwdChange) 
    { 
        if($(get-aduser $samaccountname) -ne $null)
            {
            $todouser = Get-ADUser -Server srv-dc-004 $samaccountname -Properties pwdLastSet,UserPrincipalName
            # set to 0 because 
            # $todouser.pwdLastSet = 0 
            # Set-ADUser -Instance $todouser 

            # Change the pwdlastset to the current date/time of the associate DC 
            # $todouser.pwdLastSet = -1 
            # Set-ADUser -Instance $todouser 
            $object = New-Object psobject
            $object | Add-Member NoteProperty SourceName ($samaccountname)
            $object | Add-Member NoteProperty TargetRDN ("CN=" + $($todouser.UserPrincipalName.Split("@")[0]))
            $object | Add-Member NoteProperty TargetUPN ($todouser.userPrincipalName)
            $staffUserVerwaltung  += $object

            write-host -ForegroundColor Green $_.SamAccountName $hoursdiff $domain
            # Filling the logfile 
            Add-Content $logfile "Password will be set for: $samaccountname, $lastchange, $today, $hoursdiff, $domain"
            }
            else
            {
            Add-Content $logfile "$samaccountname, is a not in INTRA please migrate User."
            } 
    } 
 
} 

################################################################################################################################################ 
# CAMPUS
################################################################################################################################################  
 
$domain = "PHBECAMPUS" 
######################################################################## 
# Set scope for effected users  --- only user who have extensionAttribute1 set.
######################################################################## 
Get-ADUser -server srv-dc-007 -Filter * -SearchBase "OU=Users,OU=PHBECampus,DC=phbecampus,DC=phbern,DC=local" -SearchScope Subtree -Properties Name,pwdLastSet ,extensionAttribute1 | ? {$_.extensionAttribute1 -ne $null} | select SamAccountName,pwdLastSet | 
 
 
######################################################################## 
# Start the real thing 
######################################################################## 
ForEach-Object { 
  $samaccountname = $_.SamAccountName 
  $today = Get-Date 
   
  # Convert the Date in a good Format 
  $lastchange = [datetime]::FromFileTime($_.pwdlastset[0]) # Convert the Date in a good Format 
 
  # Get the timedifference between last password change and the current date/time 
  $timediff = New-TimeSpan $lastchange $(Get-Date) 
   
  # Convert to difference in hours 
  $hoursdiff = $timediff.TotalHours 
 
  if ($hoursdiff -le $hourschange_sincePwdChange) 
  { 
    if($(get-aduser $samaccountname) -ne $null)
            {
            $todouser = Get-ADUser -Server srv-dc-007 $samaccountname -Properties pwdLastSet,UserPrincipalName,employeeType
            # set to 0 because 
            # $todouser.pwdLastSet = 0 
            # Set-ADUser -Instance $todouser 

            # Change the pwdlastset to the current date/time of the associate DC 
            # $todouser.pwdLastSet = -1 
            # Set-ADUser -Instance $todouser 
             $object = New-Object psobject
             $object | Add-Member NoteProperty SourceName ($samaccountname)
             $object | Add-Member NoteProperty TargetRDN ("CN=" + $($todouser.UserPrincipalName.Split("@")[0]))
             $object | Add-Member NoteProperty TargetUPN ($todouser.userPrincipalName)
                if($todouser.employeeType -eq "staff")
                    {
                     $staffUserCampus += $object
                    }
                else
                    {
                     $studentUserCampus += $object
                    }
            write-host -ForegroundColor Green $_.SamAccountName $hoursdiff $domain
            # Filling the logfile 
            Add-Content $logfile "Password will be set for: $samaccountname, $lastchange, $today, $hoursdiff, $domain" 
            }
            else
            {
            Add-Content $logfile "$samaccountname, is a not in INTRA please migrate User."
            } 
          } 
 
} 

if ($staffUserVerwaltung.Count -gt 0){$staffUserVerwaltung  | export-csv -Path $csvOutputVerwaltungStaff -NoTypeInformation -Encoding UTF8}else{Add-Content $logfile "No User found as staff in VERWALTUNG!"}
if ($staffUserCampus.Count -gt 0){$staffUserCampus| export-csv -Path $csvOutputCampusStaff -NoTypeInformation -Encoding UTF8}else{Add-Content $logfile "No User found as staff in PHBECAMPUS!"}
if ($studentUserCampus.Count -gt 0){$studentUserCampus| export-csv -Path $csvOutputCampusStudent -NoTypeInformation -Encoding UTF8}else{Add-Content $logfile "No User found as student in PHBECAMPUS!"}
Add-Content $logfile "Creating includes files finished...!"


# Using ADMT to migrate Users to INTRA and so sync PW
Add-Content $logfile "Start migrate User...!"

######################################################################## 
# Start for VERWALTUNG STAFF
Add-Content $logfile "Starting for VERWALTUNG to migrate User...!"
if (Test-Path $csvOutputVerwaltungStaff)
{
    $Parms = "USER /F:$csvOutputVerwaltungStaff /O:$optVerwaltungStaff"
    $Prms = $Parms.Split(" ")
    & "$Command" $Prms
    Add-Content $logfile "Finished for VERWALTUNG to migrate User...!"
}
else
{
Add-Content $logfile "No file found for VERWALTUNG ($csvOutputVerwaltungStaff not exist)!"
}
######################################################################## 
######################################################################## 
# Start for CAMPUS STAFF
Add-Content $logfile "Starting for PHBECAMPUS to migrate User...!"
if (Test-Path $csvOutputCampusStaff)
{
    $Parms = "USER /F:$csvOutputCampusStaff /O:$optCampusStaff"
    $Prms = $Parms.Split(" ")
    & "$Command" $Prms
    Add-Content $logfile "Finished for PHBECAMPUS to migrate User...!"
}
else
{
Add-Content $logfile "No file found for PHBECAMPUS ($csvOutputCampusStaff not exist)!"
}
######################################################################## 
######################################################################## 
# Start for CAMPUS STUDENT
Add-Content $logfile "Starting for PHBECAMPUS to migrate User...!"
if (Test-Path $csvOutputCampusStudent)
{
    $Parms = "USER /F:$csvOutputCampusStudent /O:$optCampusStudent"
    $Prms = $Parms.Split(" ")
    & "$Command" $Prms
    Add-Content $logfile "Finished for PHBECAMPUS to migrate User...!"
}
else
{
Add-Content $logfile "No file found for PHBECAMPUS ($csvOutputCampusStudent not exist)!"
}
######################################################################## 

# Password change to false
# get-ADUser -Filter * -SearchBase "OU=USR-Studierende,OU=PHBern,DC=intra,DC=phbern,DC=ch" -SearchScope Subtree | Set-ADUser -ChangePasswordAtLogon $false
# get-ADUser -Filter * -SearchBase "OU=USR-Verwaltung,OU=PHBern,DC=intra,DC=phbern,DC=ch" -SearchScope Subtree | Set-ADUser -ChangePasswordAtLogon $false

# Moving files 
Add-Content $logfile "Start Moving files...!"

foreach($file in (Get-ChildItem -Path "c:\ADMT Files\PWChanger"))
    {
     move-item $file.fullname ("c:\ADMT Files\PWChanger\Archiv\$($file.Name)-{0:yyyyMMdd}.csv" -f (get-date)) -Force
     Add-Content $logfile "Moved: $file finished...!"
    }

# End
Add-Content $logfile ("************* End of script ************* {0:yyyyMMdd}" -f (get-date))