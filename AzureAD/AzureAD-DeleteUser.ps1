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
        [int]$spalte = 1 # Spalte B
        [int]$zeile = 1 # Zeile 2 enhÃ¤lt Ãœberschrift
        $all = @()
        # $group = New-Object System.Collections.ArrayList
          
            do{
                $object = New-Object psobject 
                $object | Add-Member NoteProperty OldUpn ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty FirstName ($WorkSheet.Cells.Item($zeile,2).text)
                $object | Add-Member NoteProperty SurName ($WorkSheet.Cells.Item($zeile,3).text)
                
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

#$GlobalGroupnames = Read-excel -sheetname "GlobalGroupsExport" -file "C:\_MBA\data\unlocked_bpa_include_file_generator_mit_export_Makro_ueberarbeitet_20171211.xlsm"

$oldnames = Read-excel -sheetname "Tabelle1" -file "C:\_MBA\data\altename_v2.xlsx"



Connect-MsolService 
Get-MsolCompanyInformation

$allUPN = $null
$allUPN = get-aduser -Filter * -SearchBase "OU=Falsche,OU=USR-Studierende,OU=PHBern-Test,DC=intra,DC=phbern,DC=ch" | select UserprincipalName

# All deleted User
# Get-MsolUser -ReturnDeletedUsers

foreach($upn in $allUPN)

    {
        $ADuser = (Get-ADUser -Filter * |?{$_.UserprincipalName -eq $upn.UserprincipalName})
        $guid = [System.Convert]::ToBase64String($ADuser.ObjectGUID.tobytearray())

        foreach($old in $oldnames)
            {
            if($old.Surname -eq $ADuser.surname)
                {
                $oldUPN = $old.oldupn
                $oldUPN
                Remove-MsolUser -UserPrincipalName $($upn.UserprincipalName) -RemoveFromRecycleBin

                Set-MsolUser -UserPrincipalname $oldUPN -ImmutableID $guid
                }
            }


    }


