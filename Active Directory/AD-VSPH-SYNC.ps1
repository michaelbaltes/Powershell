function fct-ReadVsph {
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
    
        
    return  $DataSet.Tables[0].Rows
}



function fct-sortVSPHUser {
    param (
        [switch]$staff
    )
    
    if($staff)
        {
         foreach($user in $allvsphuser)
            {
                if ($user.AccountTyp -eq "Verwaltung (INTRA)" -and $user.EmailAddress.GetType().name -ne "DBNull")
                    {
 
                     # clear actual attributes for PHBern
                     Set-ADUser -Server $Server $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber,title,streetAddress,telephoneNumber,postalCode,l,description,physicalDeliveryOfficeName
                     
                     switch ($user.Basisinstitut.GetType().name) # Basisinstitut ungleich null
                        {
                        "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{department="unbekannt";departmentNumber="000"}} 
                        }
                     switch ($user.Basisinstitut) # Basisinstitut ungleich null
                        {

                        "Rektorat" {Set-ADUser -Server $Server $user.LoginName -replace @{department="Rektorat";departmentNumber="100"}}
                        "ZV" {Set-ADUser -Server $Server $user.LoginName -replace @{department="ZV";departmentNumber="110"}}
                        "IVP" {Set-ADUser -Server $Server $user.LoginName -replace @{department="IVP";departmentNumber="120"}}
                        "Sek. II" {Set-ADUser -Server $Server $user.LoginName -replace @{department="IS2";departmentNumber="140"}}
                        "Sek. I" {Set-ADUser -Server $Server $user.LoginName -replace @{department="IS1";departmentNumber="130"}}
                        "IHP" {Set-ADUser -Server $Server $user.LoginName -replace @{department="IHP";departmentNumber="150"}}
                        "IWM" {Set-ADUser -Server $Server $user.LoginName -replace @{department="IWM";departmentNumber="180"}}

                        "IFE" {Set-ADUser -Server $Server $user.LoginName -replace @{department="IFE";departmentNumber="230"}}
                        
                        "VGA" {Set-ADUser -Server $Server $user.LoginName -replace @{department="VGA";departmentNumber="310"}}
                        "VWF" {Set-ADUser -Server $Server $user.LoginName -replace @{department="VWF";departmentNumber="320"}}
                        
                        }
                     
                      switch ($user.Funktion.getType().name) # Description
                        {
                        "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{description="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{description=$user.Funktion}}
                        }
                     
                     switch ($user.PLZ.getType().name) # PLZ
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{postalCode="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{postalCode=$user.PLZ}}
                        }
                    
                    switch ($user.Stadt.getType().name) # Stadt
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{l="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{l=$user.Stadt}}
                        }
                    switch ($user.Stasse.getType().name) # Strasse
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{streetAddress="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{streetAddress=$user.Stasse}}
                        }

                    switch ($user.Raum.getType().name) # Raum
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{physicalDeliveryOfficeName="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{physicalDeliveryOfficeName=$user.Raum}}
                        }

                     switch ($user.Telefonnummer.getType().name) # Telefonnummer
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{telephoneNumber="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{telephoneNumber=$user.Telefonnummer}}
                        }
                        # title, ext1, employeenr
                        Set-ADUser -Server $Server $user.LoginName -replace @{title="staff (PHBern)";employeeType="staff";extensionAttribute1=$($user.SwissEduPersonUniqueID);employeeNumber=$($user.VSPHPersonUniqueId)}

                    }


                 elseif ($user.AccountTyp -eq "NMS (INTRA)" -and $user.EmailAddress.GetType().name -ne "DBNull")
                    {
                     # clear actual attributes for PHBern
                     Set-ADUser -Server $Server $user.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber,title,streetAddress,telephoneNumber,postalCode,l,description,physicalDeliveryOfficeName
                     
                     
                      switch ($user.Funktion.getType().name) # Description
                        {
                        "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{description="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{description=$user.Funktion}}
                        }
                     
                     switch ($user.PLZ.getType().name) # PLZ
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{postalCode="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{postalCode=$user.PLZ}}
                        }
                    
                    switch ($user.Stadt.getType().name) # Stadt
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{l="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{l=$user.Stadt}}
                        }
                    switch ($user.Stasse.getType().name) # Strasse
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{streetAddress="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{streetAddress=$user.Stasse}}
                        }

                    switch ($user.Raum.getType().name) # Raum
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{physicalDeliveryOfficeName="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{physicalDeliveryOfficeName=$user.Raum}}
                        }

                     switch ($user.Telefonnummer.getType().name) # Telefonnummer
                        {
                         "DBNull" {Set-ADUser -Server $Server $user.LoginName -replace @{telephoneNumber="keine"}}
                        default {Set-ADUser -Server $Server $user.LoginName -replace @{telephoneNumber=$user.Telefonnummer}}
                        }
                        # title, ext1, employeenr, department, depNr
                        Set-ADUser -Server $Server $user.LoginName -replace @{title="staff (NMS)";employeeType="staff";extensionAttribute1=$($user.SwissEduPersonUniqueID);employeeNumber=$($user.VSPHPersonUniqueId);department="NMS";departmentNumber="400"}
                    }
            }   
        }
}
$allvsphuser = $null
$allvsphuser = fct-ReadVsph
$server = "s-prd-dc-001.intra.phbern.ch"
$new = fct-sortVSPHUser -staff $true