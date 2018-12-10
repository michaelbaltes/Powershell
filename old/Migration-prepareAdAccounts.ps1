# ~~~~ Get all data from VSPH DB Report ~~~~
#*********************************************
$DataSet = $null
$SQLServer = "SRV-VSPH-001" #use Server\Instance for named SQL instances!
$SQLDBName = "ODS"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True;" 
#User ID= YourUserID; Password= YourPassword" 
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = 'SELECT [VSPHPersonUniqueId]
      ,[SwissEduPersonUniqueID]
      ,[EmailAddress]
      ,[LoginName]
      ,[AccountTyp]
      ,[Domain]
      ,[Basisinstitut]
      ,[AnzahlAccounts]
  FROM [ODS].[fIT].[Accounts]'

$SqlCmd.Connection = $SqlConnection 
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd 
#$SqlAdapter.SelectCommand = $SqlCmd2 
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) 
$SqlConnection.Close() 

# ~~~~ Get all data from VSPH DB Report ~~~~
#***********************************************

 $Institut = "Rektorat"
 switch ($Institut)
     {
       "Rektorat"{$InstitutID = "100"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  }
       "ZV"{$InstitutID = "110"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  }
       "IVP*"{$InstitutID = "120"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  }
       "Sek. I*"{$InstitutID = "130"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  }
       "Sek. II*"{$InstitutID = "140"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  } 
       "IVP*"{$InstitutID = "150"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  } 
       "IWM*"{$InstitutID = "180"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  } 
       "IFE*"{$InstitutID = "230"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  } 
       "VWF"{$InstitutID = "320"; Write-Warning "Institut was set to: $Institut with ID $InstitutID !"  } 
       default {}

     }
# ~~~~~~ Alle Benutzer die Mitarbeitend sind!~~~~~~~
#***************************************************
 function PH-Set-ACccountAttributes()
 {
     foreach($user in $DataSet.Tables[0].Rows)
        {
        if ($user.AnzahlAccounts -eq "1" -and $user.Basisinstitut -eq $Institut -and $user.AccountTyp -like "Mitarbeitend*")
            {
            # Löschen der bestehenden Werte - cleanup!
            Set-ADUser $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
            # Neue Werte schreiben
            Set-ADUser $user.LoginName -add @{department=$user.Basisinstitut;departmentNumber=$InstitutID;employeeType="staff";extensionAttribute1=$user.SwissEduPersonUniqueID;employeeNumber=$user.VSPHPersonUniqueId}
            $user
            }
    
        }
}
# ~~~~~~ Alle Benutzer die Mitarbeitend sind!~~~~~~~
#***************************************************

function PH-SetAccountUPN()
{
 foreach($user in $DataSet.Tables[0].Rows)
        {
        if ($user.AnzahlAccounts -eq "1" -and $user.Basisinstitut -eq $Institut -and $user.AccountTyp -like "Mitarbeitend*")
            {
            Write-Warning "Now setting UPN for $($user.loginName) to $($user.EmailAddress) !!"
            Set-ADUser $user.LoginName -userPrincipalName $user.EmailAddress
            }
        }
}
PH-SetAccountUPN