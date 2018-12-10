# $usertomigrate = Get-ADUser -Filter "mail -like '*@phbern.ch' -and enabled -eq 'True'" -properties * | where {$_.LastlogonDate -ne $null -and $_.DistinguishedName -notlike "*OU=Unpersönliche Accounts*" -and $_.homeDirectory -ne $null } # |  measure

 <#   
foreach($u in $usertomigrate) {
    switch -Wildcard ($u.DistinguishedName)
        {
        "*OU=ZV*"{Set-ADUser $u.samaccountname -Department 'ZV' -Add @{departmentNumber='110'; employeeType='staff'; extensionAttribute1=$u.SamAccountName}}
        "*OU=Rektorat*"{Set-ADUser $u.samaccountname -Department 'Rektorat' -Add @{departmentNumber='100'; employeeType='staff'; extensionAttribute1=$u.SamAccountName}}
        "*OU=IVP*"{Set-ADUser $u.samaccountname -Department 'IVP' -Add @{departmentNumber='120'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        "*OU=IS1*"{Set-ADUser $u.samaccountname -Department 'IS1' -Add @{departmentNumber='130'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        "*OU=IS2*"{Set-ADUser $u.samaccountname -Department 'IS2' -Add @{departmentNumber='140'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        "*OU=IHP*"{Set-ADUser $u.samaccountname -Department 'IHP' -Add @{departmentNumber='150'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        "*OU=IWM *"{Set-ADUser $u.samaccountname -Department 'IWM' -Add @{departmentNumber='180'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        "*OU=IFE*"{Set-ADUser $u.samaccountname -Department 'IFE' -Add @{departmentNumber='230'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        "*OU=VGA*"{Set-ADUser $u.samaccountname -Department 'VGA' -Add @{departmentNumber='310'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        #"*IWM*"{Set-ADUser $u.samaccountname -Department 'IWM' -Add @{departmentNumber='320'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}
        "*OU=NMS*"{Set-ADUser $u.samaccountname -Department 'NMS' -Add @{departmentNumber='400'; employeeType='staff'; extensionAttribute1=$u.samaccountname}}

        }
    }
#>
# Get-ADUser -Filter "name -eq 'PHBEBET10579'" -Properties * | Set-ADUser 'PHBEBET10579' -Department 'ZV' -Add @{departmentNumber='110'; employeeType='staff'; extensionAttribute1='PHBEBET10579'}
<#
$u = get-aduser -filter "Name -eq 'PHBEMIC10551'" -Properties *
switch -Wildcard ($u.DistinguishedName) {
    "*ZV*"{Set-ADUser $usertomigrate.samaccountname -Department 'ZV' -Add @{departmentNumber='110'; employeeType='staff'; extensionAttribute1=$usertomigrate.samaccountname}}
}

foreach ($i in $usertomigrate){
    
      $count +=1
      $b =  "{0:00000000}" -f $count 
      $b 
    Set-ADUser $i.samaccountname -EmployeeID $b
    }
    #>
    function Read-excel ($sheetname, $file) {
        # Object erstellen
        $objExcel = New-Object -ComObject Excel.Application
        $objExcel.Visible = $false
        # Datei anschnallen
        $WorkBook = $objExcel.Workbooks.Open($file)
    
        # welche mappen gibt es?
        $sheet =  ($WorkBook.sheets | Select-Object -Property Name).Name
       
        # Mappe öffnen
        $WorkSheet = $WorkBook.Worksheets.Item($sheetname)
    
        # Starte mit Zeile n
        [int]$spalte = 2 # Spalte B
        [int]$zeile = 2 # Zeile 2 enhält Überschrift
        $all = @()
        # $group = New-Object System.Collections.ArrayList
          
            do{
                $object = New-Object psobject 
                $object | Add-Member NoteProperty Login ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty Mail ($WorkSheet.Cells.Item($zeile,3).text)
                $object | Add-Member NoteProperty SwissEduID ($WorkSheet.Cells.Item($zeile,4).text)
                $object | Add-Member NoteProperty AD ($WorkSheet.Cells.Item($zeile,5).text)
                $object | Add-Member NoteProperty VSPHID ($WorkSheet.Cells.Item($zeile,6).text)
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
# Region Rektorat
<#
   $all = $null
   $userTomigrate = $null
   $userTomigrate =  Read-excel -sheetname 'Rektorat (100)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
   foreach($u in $usertomigrate) 
   {
        if ($u.AD -eq "Mitarbeitend (Verwaltung)")
        {
            $currentuser = get-aduser $u.Login -Properties *
            if (($currentuser | select employeenumber).employeenumber -eq $null)
            {
            write-host $u.Login " gefunden und wird nun bearbeitet"
            Set-ADUser $currentuser.samaccountname -Department 'Rektorat' -Add @{departmentNumber='100'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
            write-host $u.Login "wurden Attribute neu gesetzt!"
            }
        }   
    }
#>
# Region end

# Region ZV
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'ZV (110)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'ZV' -Add @{departmentNumber='110'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end


# Region IVP
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'IVP (120)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'IVP' -Add @{departmentNumber='120'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end

# Region IS1
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'IS1 (130)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)" -or $u.AD -eq "Assistierend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'IS1' -Add @{departmentNumber='130'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end

# Region IS2
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'IS2 (140)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)" -or $u.AD -eq "Assistierend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'IS2' -Add @{departmentNumber='140'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end

# Region IHP
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'IHP (150)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)" -or $u.AD -eq "Assistierend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'IHP' -Add @{departmentNumber='150'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end

# Region IWM
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'IWM (180)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)" -or $u.AD -eq "Assistierend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'IWM' -Add @{departmentNumber='180'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end

# Region IFE
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'IFE (230)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)" -or $u.AD -eq "Assistierend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'IFE' -Add @{departmentNumber='230'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end


# Region VGA
<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'VGA (310)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)" -or $u.AD -eq "Assistierend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'VGA' -Add @{departmentNumber='310'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end

# Region VWF
#<#
$all = $null
$userTomigrate = $null
$userTomigrate =  Read-excel -sheetname 'VWF (320)' -file 'c:\_mba\data\AlleUser-ausVSPH.xlsx'
foreach($u in $usertomigrate) 
{
     if ($u.AD -eq "Mitarbeitend (Verwaltung)" -or $u.AD -eq "Assistierend (Verwaltung)")
     {
         $currentuser = get-aduser $u.Login -Properties *
         if (($currentuser | select employeenumber).employeenumber -eq $null)
         {
         write-host $u.Login " gefunden und wird nun bearbeitet"
         Set-ADUser $currentuser.samaccountname -Department 'VWF' -Add @{departmentNumber='320'; employeeType='staff'; extensionAttribute1=$u.Login; extensionAttribute2=$u.SwissEduID; employeenumber=$u.VSPHID}
         write-host $u.Login "wurden Attribute neu gesetzt!"
         }
     }   
 }
#>
# Region end
