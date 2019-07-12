#get-aduser -Server srv-dc-007 -Filter * -Properties * -SearchBase "OU=Studierende,OU=Users,OU=PHBECampus,DC=phbecampus,DC=phbern,DC=local" | ?{$_.department -ne $null} | select name, department


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


 foreach($VSPHUser in $DataSet.Tables[0].Rows)

     {
        if($VSPHUser.AccountTyp -eq "Studierend (PHBECampus)" -and $VSPHUser.Basisinstitut.GetType().name -ne "DBNull")
            {
            $VSPHUser.LoginName | Out-File C:\_MBA\data\Studis_mitAnstellung.txt -Append utf8
            #$server = "srv-dc-007"
            #Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
            #Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);employeeType="student";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
            }

     }