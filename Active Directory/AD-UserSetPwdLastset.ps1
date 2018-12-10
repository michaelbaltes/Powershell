
 $ZV = Get-ADUser -Filter * -SearchBase "OU=USR-Verwaltung,OU=PHBern,DC=intra,DC=phbern,DC=ch" -Properties * | where {$_.PasswordNeverExpires -eq $true} # "departmentnumber -ne 110"
foreach ($user in $zv)
    {
    
     $user.pwdLastSet = 0 
     Set-ADUser -Instance $user 

     $user.pwdLastSet = -1
     Set-ADUser -Instance $user 
     Set-ADUser $user -CannotChangePassword $false -PasswordNeverExpires $false # passwordneverexpires $false
    
     Write-host $user.DisplayName " was changed"        
    }


<#
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

    $DataSet.Tables[0].Rows | Out-GridView
#>