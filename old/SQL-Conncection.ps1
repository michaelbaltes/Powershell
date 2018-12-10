<#
$SQLServer = "SRV-VSPH-001"
$SQLDBName = "ODS"
$SqlQuery = ""
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True;"
#>

# database Intraction
# Abfrage
<#
SELECT [VSPHPersonUniqueId]
      ,[SwissEduPersonUniqueID]
      ,[EmailAddress]
      ,[LoginName]
      ,[AccountTyp]
      ,[Domain]
      ,[Basisinstitut]
      ,[AnzahlAccounts]
  FROM [ODS].[fIT].[Accounts] 
  WHERE [AnzahlAccounts] = 2
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

#Ausgabe 
# $DataSet.Tables

# Erster Eintrag
# $DataSet.Tables[0].Rows[0].EmailAddress.Split("@")


<# Mail vergleich
$praeffix = [System.Collections.ArrayList]@()
foreach($user in $DataSet.Tables[0].Rows)
{


if($user.EmailAddress.GetType().name -eq "String")
{
$mail = $user.EmailAddress.Split("@")[0]
    $praeffix.add($mail)
}
else
{
$praeffix.Add("NO MAIL")
}



}
$praeffix
#End :database Intraction
clear


$nachher = $praeffix | select -Unique                                                                                                                                                    
Compare-Object -ReferenceObject $nachher -DifferenceObject $praeffix                                                                                                                     
 #>
 $Institut = "Rektorat"
 $InstitutID = ""
 foreach($user in $DataSet.Tables[0].Rows)
    {
    if ($user.SwissEduPersonUniqueID.GetType().name -eq "DBNull")
        {
        $user | Export-Csv -Path C:\_MBA\data\ohneEDUID.csv -Append -Encoding UTF8 -NoTypeInformation
        #Set-ADUser $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
        #Set-ADUser $user.LoginName -add @{department=$($user.Basisinstitut);departmentNumber=$($user.departmentNumber);employeeType="$user.employeeType";extensionAttribute1="$user.extensionAttribute1";extensionAttribute2="$user.extensionAttribute2";employeeNumber="$user.employeeNumber"}
        }
    
    }