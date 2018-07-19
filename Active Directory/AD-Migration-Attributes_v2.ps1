
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

# ------------------------- !!!! VARIABLEN !!!!!
 $Institut = "Sek. II"
 $InstitutID = "140"
 $Typ = "Studierend*"
 $TypAD = "staff"
 $Server = $null

 #------------------------- WICHTIG!!!!! If Users read from Text File
        
        $getUserfromText = $false
        if ($getUserfromText){$usersfromtext = Get-Content -Path "C:\_MBA\data\NMS-mail.txt"}

#------------------------- WICHTIG!!!!! If Users read from Text File

<#
ID	Name	Kürzel
100	Rektorat	Rektorat
110	Zentrale Verwaltung	ZV
120	Institut Vorschulstufe und Primarstufe	IVP
130	Institut Sekundarstufe I	Sek. I
140	Institut Sekundarstufe II	Sek. II
150	Institut für Heilpädagogik	IHP
180	Institut für Weiterbildung und Medienbildung	IWM
230	Institut für Forschung, Entwicklung und Evaluation	IFE
310	Verwaltung Grundausbildungen	VGA
320	Verwaltung Weiterbildung und Forschung	VWF
400	Privates Institut Vorschulstufe und Primarstufe (NMS)	NMS
#>







####------MAIN-----########

# !!!!! Doit for VSPH direct
if(!($getUserfromText))
{
 foreach($user in $DataSet.Tables[0].Rows)
    {
    #if ($user.AnzahlAccounts -eq "1" -and $user.Basisinstitut -eq $Institut -and $user.AccountTyp -like $Typ)
    if ($user.Massnahme -eq "$Institut")
        {
        if($user.Domain -eq "PHBECampus")
            {
            $Server = "srv-dc-007"
            if((get-aduser -Server $Server $user.LoginName).UserPrincipalName -like "*phbern.local")
                {
                $user
                Set-ADUser -Server $Server $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                Set-ADUser -Server $Server $user.LoginName -replace @{UserPrincipalName=$($user.EmailAddress);department=$Institut;departmentNumber=$InstitutID;employeeType=$TypAD;extensionAttribute1=$($user.SwissEduPersonUniqueID);employeeNumber=$($user.VSPHPersonUniqueId)}
                get-aduser -Server $Server $user.LoginName -Properties * | select samaccountName, UserPrincipalName,extensionAttribute1,extensionAttribute2,employeeNumber,mail | Export-Csv -Path C:\_mba\Data\neuDoppelete-UPN-$InstitutID-$Server.csv -NoTypeInformation -Append -Encoding UTF8
                }
            }
        else
            {
            $Server = "srv-dc-004"
            if((get-aduser -Server $Server $user.LoginName).UserPrincipalName -like "*phbern.local")
                {
                $user
                Set-ADUser -Server $Server $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                Set-ADUser -Server $Server $user.LoginName -replace @{UserPrincipalName=$($user.EmailAddress);department=$Institut;departmentNumber=$InstitutID;employeeType=$TypAD;extensionAttribute1=$($user.SwissEduPersonUniqueID);employeeNumber=$($user.VSPHPersonUniqueId)}
                get-aduser -Server $Server $user.LoginName -Properties * | select samaccountName, UserPrincipalName,extensionAttribute1,extensionAttribute2,employeeNumber,mail | Export-Csv -Path C:\_mba\Data\neuDoppelete-UPN-$InstitutID-$Server.csv -NoTypeInformation -Append -Encoding UTF8
                }
            }
        }
    
    } 
}
else
{ # !!!! ------------------------- Doit from Text-File
foreach($temp in $usersfromtext)
    {
        foreach($user in $DataSet.Tables[0].Rows)
        {
        if ($user.EmailAddress -eq $temp )
        #if ($user.LoginName -eq $temp )
            {
            if($user.Domain -eq "PHBECampus")
                {
                $Server = "srv-dc-007"
                Set-ADUser -Server $Server $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                Set-ADUser -Server $Server $user.LoginName -replace @{UserPrincipalName=$($user.EmailAddress);department="NMS";departmentNumber=$InstitutID;employeeType=$TypAD;extensionAttribute1=$($user.SwissEduPersonUniqueID);employeeNumber=$($user.VSPHPersonUniqueId)}
                #Set-ADUser -Server $Server $user.LoginName -replace @{department=$($user.Basisinstitut);departmentNumber="0";employeeType="doppleteMailbox";employeeNumber=$($user.VSPHPersonUniqueId)}
                get-aduser -Server $Server $user.LoginName -Properties * | select samaccountName, UserPrincipalName,extensionAttribute1,extensionAttribute2,employeeNumber,department,mail | Export-Csv -Path C:\_mba\Data\UPN-NMS-$Server.csv -NoTypeInformation -Append -Encoding UTF8
                }
            else
                {
                $Server = "srv-dc-004"
                Set-ADUser -Server $Server $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                Set-ADUser -Server $Server $user.LoginName -replace @{UserPrincipalName=$($user.EmailAddress);department="NMS";departmentNumber=$InstitutID;employeeType=$TypAD;extensionAttribute1=$($user.SwissEduPersonUniqueID);employeeNumber=$($user.VSPHPersonUniqueId)}
                #Set-ADUser -Server $Server $user.LoginName -replace @{department=$($user.Basisinstitut);departmentNumber="0";employeeType="doppleteMailbox";employeeNumber=$($user.VSPHPersonUniqueId)}
                get-aduser -Server $Server $user.LoginName -Properties * | select samaccountName, UserPrincipalName,extensionAttribute1,extensionAttribute2,employeeNumber,department,mail | Export-Csv -Path C:\_mba\Data\UPN-NMS-$Server.csv -NoTypeInformation -Append -Encoding UTF8
                }

            }
         }
        
    }
}


