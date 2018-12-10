function Read-excel ($sheetname, $file) {
        # Object erstellen
        $objExcel = New-Object -ComObject Excel.Application
        $objExcel.Visible = $false
        # Datei anschnallen
        $WorkBook = $objExcel.Workbooks.Open($file)
    
        # welche mappen gibt es?
        $sheet =  ($WorkBook.sheets | Select-Object -Property Name).Name
       
        # Mappe Ã¶ffnen
        $WorkSheet = $WorkBook.Worksheets.Item($sheetname)
    
        # Starte mit Zeile n
        [int]$spalte = 2 # Spalte B
        [int]$zeile = 2 # Zeile 2 enhÃ¤lt Ãœberschrift
        $all = @()
        # $group = New-Object System.Collections.ArrayList
          
            do{
                $object = New-Object psobject 
                $object | Add-Member NoteProperty SourceName ($WorkSheet.Cells.Item($zeile,1).text)
                $object | Add-Member NoteProperty TargetRDN ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty TargetUPN ($WorkSheet.Cells.Item($zeile,3).text)
                $zeile++ | Out-Null

                $all += $object
            }
            while($WorkSheet.Cells.Item($zeile,$spalte).text.length -gt 0)
            # Write-Warning $zeile
            #COM-Objektes beenden
        $objExcel.Quit()
        #COM-Objektes aus dem Speicher entfernen
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)  
    
        return $all
    }

function VSPH-Reader ()
{
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

return $DataSet

}
$VSPHdata = $null
$VSPHdata = VSPH-Reader
#$VSPHdata.tables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Variables Control before start script ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# **************************************************************************************************************************
$Server = "srv-dc-007.verwaltung.phbern.local"
$Inputfile = "C:\_MBA\data\AccountsSeit20180319.xls"
$OutputFile = "C:\Scripte\Daten\csv\AccountsSeit20180319_Test1.csv"
$UseforGroups = $false # $true
$CreateCSV = $false # true
#$useExcel = $false
# **************************************************************************************************************************
$ExcelContent = $null
# Read Source file
if($Inputfile.EndsWith(".csv")){
$ExcelContent = import-csv -Path $Inputfile -Delimiter "    "
}
else
{
$ExcelContent = Read-excel -sheetname "Tabelle1" -file $Inputfile
}

$AllGroups = @()

if($UseforGroups)
{

    foreach($localG in $ExcelContent)
    {
        if ($localG.TargetUPN -ne $null)
        {
            $o = $localG.SourceName
            # Extend old groups with infos
            Get-ADGroup -Server $Server -filter {name -eq $o} | Set-ADGroup -replace @{extensionAttribute1=$localG.newname;extensionAttribute2=$localG.oldName}

            # create object for csv export to migrate with ADMT
            $Groupobject = New-Object psobject
            $Groupobject | Add-Member NoteProperty SourceName ($localG.SourceName)
            $Groupobject | Add-Member NoteProperty TargetRDN ("CN=" + $localG.NewName)
            $Groupobject | Add-Member NoteProperty TargetUPN ($localG.NewName)

            $AllGroups += $Groupobject
        }
    }
  }
else
{
foreach($xlsUser in $ExcelContent)
    {
        if ($xlsUser.TargetUpn -ne $null)
        {
            # $o = $localG.OldName
            # Extend old groups with infos
            # Get-ADuser -Server $Server -filter {name -eq $o} #| Set-ADGroup -replace @{extensionAttribute1=$localG.newname;extensionAttribute2=$localG.oldName}
            foreach($VSPHUser in $VSPHdata.tables)
            {
            if($xlsUser.TargetUPN -eq $VSPHUser.EmailAddress)
            {
                Write-host -ForegroundColor Green "Bearbeite User: $xlsUser" 
                switch -Wildcard ($VSPHUser.Basisinstitut) 
                {
                    "Rektorat*"
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="100";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "ZV*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="110";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "IVP*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="120";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "Sek. I*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="130";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "Sek. II*"
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="140";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "IHP*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="150";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "IWM*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="180";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "IFE*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="230";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "VGA*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="310";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    "VWF*" 
                    {if ($VSPHUser.Domain -eq "Verwaltung") {$Server = "srv-dc-004"} else {$Server = "srv-dc-007"}
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    if($VSPHUser.EmailAddress -like "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);department=$VSPHUser.Basisinstitut;departmentNumber="320";employeeType="staff";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}; break
                    }
                    Default 
                    {Write-host -ForegroundColor Green "No User found as staff! Set students now..."
                    if($VSPHUser.EmailAddress -notlike "*@stud.phbern.ch"){ Write-host -ForegroundColor Red "User mit falscher Email Adresse: $xlsUser" }
                    $Server = "srv-dc-007"
                    # $user = (get-aduser -Server $Server $VSPHUser.LoginName).UserPrincipalName
                    Set-ADUser -Server $Server $VSPHuser.LoginName -clear department,departmentNumber,employeeType,extensionAttribute1,extensionAttribute2,employeeNumber
                    Set-ADUser -Server $Server $VSPHuser.LoginName -replace @{UserPrincipalName=$($VSPHuser.EmailAddress);extensionAttribute2="student";extensionAttribute1=$($VSPHUser.SwissEduPersonUniqueID);employeeNumber=$($VSPHUser.VSPHPersonUniqueId)}
                    }
                }
              }
            }


            if ($CreateCSV)
            {
            # create object for csv export to migrate with ADMT
            $Groupobject = New-Object psobject
            $Groupobject | Add-Member NoteProperty SourceName ($xlsUser.SourceName)
            $Groupobject | Add-Member NoteProperty TargetRDN ("CN=" + $xlsUser.NewName.Split("@")[0])
            $Groupobject | Add-Member NoteProperty TargetUPN ($xlsUser.NewName)

            $AllGroups += $Groupobject
            }
        }
    }
}


# Export groups to csv
if ($CreateCSV){
$AllGroups | export-csv -Path $OutputFile -NoTypeInformation -Encoding UTF8 
}

