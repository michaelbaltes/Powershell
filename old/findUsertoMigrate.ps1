$logfile = "C:\_mba\data\MigrationsCheck\usercheck"
$logdate = Get-Date -format yyyyMMdd 
$logfile = $logfile + "_$logdate.log"
Add-Content $logfile ("************* Starting Script ************* {0:yyyyMMdd}" -f (get-date))

Add-Content $logfile "Connect to VSPH."
$SQLServer = "SRV-VSPH-001" #use Server\Instance for named SQL instances!
$SQLDBName = "ODS"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True;" 
#User ID= YourUserID; Password= YourPassword" 
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = 'SELECT * FROM [ODS].[fIT].[Accounts]'
$SqlCmd.Connection = $SqlConnection 
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd 
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) 
$SqlConnection.Close() 
Add-Content $logfile "Ready to work with VSPH data."

$cstudents = @()
$cstaff = @()
$object
foreach($user in $DataSet.Tables[0].Rows)
    {
        if ($user.eMailAddress.GetType().name -ne "DBNull")
            {
                 try
                  {
                   Get-ADUser $user.LoginName | Out-Null
                   write-host -ForegroundColor Green "$($user.LoginName) found!" 
                   Add-Content $logfile "Found $($user.LoginName)"
                  }
                 Catch
                  {
                   
                   Add-Content $logfile "Failed to get User: $($user.LoginName), Anzahl: $($user.AnzahlAccounts)"

                   if($user.AccountTyp -eq "Studierend (PHBECampus)")
                    {
                    write-host -ForegroundColor Yellow "$($user.LoginName) not found! Create CSV to migrate them as student...."
                    $object = New-Object psobject
                    $object | Add-Member NoteProperty SourceName ($user.LoginName)
                    $object | Add-Member NoteProperty TargetRDN ("CN=" + $user.EmailAddress.Split("@")[0])
                    $object | Add-Member NoteProperty TargetUPN ($user.EmailAddress)
                    $cstudents += $object
                    }
                   else
                    {
                    write-host -ForegroundColor Yellow "$($user.LoginName) not found! Create CSV to migrate them as staff...."                    
                    $object = New-Object psobject
                    $object | Add-Member NoteProperty SourceName ($user.LoginName)
                    $object | Add-Member NoteProperty TargetRDN ("CN=" + $user.EmailAddress.Split("@")[0])
                    $object | Add-Member NoteProperty TargetUPN ($user.EmailAddress)
                    $cstaff += $object                    
                    }
                  }  
            }
    }

    $cstudents | Export-Csv -Path C:\_MBA\data\ADMT\studis-noch-nicht-migriert.csv -Append -Encoding UTF8 -NoTypeInformation
    $cstaff | Export-Csv -Path C:\_MBA\data\ADMT\staff-noch-nicht-migriert.csv -Append -Encoding UTF8 -NoTypeInformation
            