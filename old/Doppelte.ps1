
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
$dopplete = @()

$DataSet.Tables[0].Rows | foreach {

    
    if($_.anzahlAccounts -ne 1 )#-and $_.EmailAddress.gettype().name -eq "DBNull")
            {
            $dopplete += $_
            }
         
         }
$dopplete.count
# $dopplete | %{$_ | select VSPHPersonUniqueId,LoginName,EmailAddress | sort -Property VSPHPersonUniqueId | export-csv -Path C:\_MBA\data\doppelteAccounts_20181105.csv -Append -NoTypeInformation -Encoding UTF8} 

foreach($user in $dopplete)
{
    $dopplete | foreach {if($_.VSPHPersonUniqueId -eq $user.VSPHPersonUniqueId -and !($_.LoginName -eq $User.LoginName))
                            {
                            #if($_.EmailAddress.gettype().name -ne "DBNull")
                            if($_.EmailAddress.gettype().name -eq "DBNull")
                               { 
                                write-host -ForegroundColor Green "Hauptaccount:" $user.LoginName
                             
                                write-host -ForegroundColor Yellow "Nebenaccount:" $_.LoginName
                                if($_.Domain -eq "Verwaltung" -and  $_.EmailAddress -notlike "*nms.phbern.ch")
                                    {
                                    #Get-ADuser -server srv-dc-004 $user.LoginName -Properties *
                                    #Get-ADPrincipalGroupMembership -Server srv-dc-004 $_.LoginName | select Name | Out-File C:\_MBA\data\Doppelete\$($_.loginname).txt -Append
                                    #"Hauptaccount: $($user.LoginName) " | Out-File C:\_MBA\data\Doppelete\$($_.loginname).txt -Append
                                    get-aduser -Server srv-dc-004 $_.LoginName -Properties HomeDirectory
                                    }
                                elseif($_.Domain -ne "Verwaltung" -and $_.EmailAddress -notlike "*nms.phbern.ch") 
                                    {
                                    #Get-ADPrincipalGroupMembership -Server srv-dc-007 $_.LoginName | select Name | Out-File C:\_MBA\data\Doppelete\$($_.loginname).txt -Append
                                    #"Hauptaccount: $($user.LoginName) " | Out-File C:\_MBA\data\Doppelete\$($_.loginname).txt -Append
                                    get-aduser -Server srv-dc-007 $_.LoginName -Properties HomeDirectory
                                    }
                                }
                            }
                        }
}