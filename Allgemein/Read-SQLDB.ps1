function Read-Vsph {
    $SQLServer = "SRV-VSPH-001.verwaltung.phbern.local" #use Server\Instance for named SQL instances!
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
    
        
    return  $DataSet.Tables[0].Rows
}

