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

foreach($user in $DataSet.Tables[0].Rows)

    {
     if($user.Domain -eq "PHBECampus")
        {
         if ($(get-aduser -server "srv-dc-007" $user.loginName -Properties extensionAttribute1, name | ?{$_.extensionAttribute1 -eq $Null}) -and $user.Massnahme.GetType().name -eq "DBNull")
            {
             Write-Host -ForegroundColor Red $user.LoginName
             $user.LoginName | Out-File C:\_MBA\data\user-PHBECAMPUS.txt -Append
            }
        }
        else
        {
         if ($(get-aduser -server "srv-dc-004" $user.loginName -Properties extensionAttribute1, name | ?{$_.extensionAttribute1 -eq $Null}) -and $user.Massnahme.GetType().name -eq "DBNull")
            {
             Write-Host -ForegroundColor Red $user.LoginName
             $user.LoginName | Out-File C:\_MBA\data\user-VERWALTUNG.txt -Append
            }
        }

    }