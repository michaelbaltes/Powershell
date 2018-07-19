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
        [int]$zeile = 2 # Zeile 2 enhÃ¤lt Ãœberschrift
        $all = @()
        # $group = New-Object System.Collections.ArrayList
          
            do{
                $object = New-Object psobject 
                $object | Add-Member NoteProperty OldName ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty NewName ($WorkSheet.Cells.Item($zeile,5).text)
                #$object | Add-Member NoteProperty Notes ($WorkSheet.Cells.Item($zeile,3).text)
                
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

   $groupnames = Read-excel -sheetname "Tabelle1" -file "C:\_MBA\data\Gruppen\gruppen.xlsx"
   $AllGroups = @()

   foreach($group in $groupnames)
    {
    if($group -ne "0")
        {
            $Groupobject = New-Object psobject
            $Groupobject | Add-Member NoteProperty SourceName ($group.oldname)
            $Groupobject | Add-Member NoteProperty TargetRDN ("CN=" + $group.NewName)
            $Groupobject | Add-Member NoteProperty TargetUPN ($group.NewName)

            $AllGroups += $Groupobject
        #Get-ADGroup -server srv-dc-007.phbecampus.phbern.local $group.oldname | Set-ADGroup -server srv-dc-007.phbecampus.phbern.local -replace @{extensionAttribute2=$group.oldname;extensionAttribute1=$group.newName}
        }
    }
    $AllGroups | export-csv -Path C:\_MBA\data\Gruppen\Migration-Gruppen-20180524.csv -Append -NoTypeInformation -Encoding UTF8