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

# $userfromfile = Get-Content C:\_MBA\data\IntraUser.txt

#foreach($user in $userfromfile)
  #  {
       foreach($VSPHUser in $DataSet.Tables[0].Rows)
        {
            if($VSPHuser.Basisinstitut.GetType().name -eq "DBNull" -and $VSPHUser.AccountTyp -ne "Studierend (PHBECampus)")
                {
                 switch -Wildcard ($VSPHUser.Massnahme) 
                            {
                                "Rektorat*"
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break}
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="100";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "ZV*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="110";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IVP*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="120";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "Sek. I" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="130";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "Sek. II*"
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="140";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IHP*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="150";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IWM*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="180";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IFE*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="230";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "VGA*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="310";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "VWF*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Massnahme;departmentNumber="320";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                #Default 
                                #{Write-host -ForegroundColor Green "No User found as staff! Set students now..."
                                #if($VSPHUser.EmailAddress -notlike "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $User" }
                                #$Server = "srv-dc-007"
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                #Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                #Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);employeeType="student";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                #}
                            }
                }
             else
                {
                 switch -Wildcard ($VSPHUser.Basisinstitut) 
                            {
                                "Rektorat*"
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="100";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "ZV*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="110";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IVP*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="120";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "Sek. I" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="130";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "Sek. II*"
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="140";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IHP*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="150";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IWM*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="180";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "IFE*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="230";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "VGA*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="310";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                                "VWF*" 
                                {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                                # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                                if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse:$($VSPHUser.LoginName)"  ; break }
                                Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                                Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="320";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                                Write-host -ForegroundColor Green "User bearbeitet: $($VSPHUser.LoginName)" ; break
                                }
                        }
                }

            #}
    }