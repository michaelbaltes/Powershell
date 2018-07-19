<# $GP = Get-Content -Path C:\_MBA\data\GP-Verwaltung.txt
foreach($i in $GP)
{
get-aduser -Filter {UserPrincipalName -eq $i} -Properties DisplayName  | % {$_ |select DisplayName | Out-File C:\_MBA\data\GP-Verwaltung-Display.txt -Append}
}
write-host "hello" #>


#get-aduser -Filter * -SearchBase "OU=CampusUsers,OU=Users,OU=PHBECampus,DC=phbecampus,DC=phbern,DC=local" -Server srv-dc-007 -Properties lastlogondate  | export-csv -Path C:\_MBA\data\LastLogon-Campus.csv -Append -NoTypeInformation -Encoding UTF8
# %{
    #set-aduser $_.SamAccountName -clear description, department
#     set-aduser $_.SamAccountName -Replace @{title="staff (NMS)"}
# }
<# foreach ($pc in (Get-Content -Path C:\_MBA\data\015_freitag_campus.csv)) {

    &PING.EXE $pc | out-grid
}
 
$all = $null
$i = $null
$all= Import-Csv -Path C:\_MBA\data\new-attributes.csv 
#>


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
$i = $null
foreach ($user in $DataSet.Tables[0].Rows)
{
    if ($user.PLZ.gettype().name -ne "DBNull" -or $user.Telefonnummer.gettype().name -ne "DBNull" -or $user.Raum.gettype().name -ne "DBNull" -or $user.Funktion.gettype().name -ne "DBNull" -or $user.Stasse.gettype().name -ne "DBNull" -or $user.Stadt.gettype().name -ne "DBNull")
        {
            $i ++
        #PLZ
        if ($user.PLZ.gettype().name -ne "DBNull")
        {
        
            Write-host "***** bearbeite Account Nummer: $i User: "  $user.LoginName "und aendere die PLZ."
            set-aduser $user.LoginName -Clear postalCode
            set-aduser $user.LoginName -replace @{postalCode=$user.PLZ}
        }
        # Telefonummer
        if ($user.Telefonnummer.gettype().name -ne "DBNull")
        {
            Write-host "***** bearbeite Account Nummer: $i User: "  $user.LoginName "und aendere die Telefonummer."
            set-aduser $user.LoginName -Clear telephoneNumber
            set-aduser $user.LoginName -replace @{telephoneNumber=$user.Telefonnummer}
        }
        # Raum
        if ($user.Raum.gettype().name -ne "DBNull")
        {
            Write-host "***** bearbeite Account Nummer: $i User: "  $user.LoginName "und aendere den Raum."
            set-aduser $user.LoginName -Clear physicalDeliveryOfficeName
            set-aduser $user.LoginName -replace @{physicalDeliveryOfficeName=$user.Raum}
        }
        # Funktion
        if ($user.Funktion.gettype().name -ne "DBNull")
        {
            Write-host "***** bearbeite Account Nummer: $i User: "  $user.LoginName "und aendere die Funktion"
            set-aduser $user.LoginName -Clear description
            set-aduser $user.LoginName -replace @{description=$user.Funktion}
        }
        # Strasse
        if ($user.Stasse.gettype().name -ne "DBNull")
        {
            Write-host "***** bearbeite Account Nummer: $i User: "  $user.LoginName "und aendere die Strasse"
            set-aduser $user.LoginName -Clear streetAddress
            set-aduser $user.LoginName -replace @{streetAddress=$user.Stasse}
        }
        # Stadt
        if ($user.Stadt.gettype().name -ne "DBNull" )
        {
            Write-host "***** bearbeite Account Nummer: $i User: "  $user.LoginName "und aendere die Stadt" 
            set-aduser $user.LoginName -Clear l
            set-aduser $user.LoginName -replace @{l=$user.stadt}
        }
    }
}
