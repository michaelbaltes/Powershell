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
        [int]$spalte = 3 # Spalte C
        [int]$zeile = 2 # Zeile 2 enhält Überschrift
        $all = @()
        # $group = New-Object System.Collections.ArrayList
          
            do{
                $object = New-Object psobject 
                $object | Add-Member NoteProperty Username ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty Domain ($WorkSheet.Cells.Item($zeile,4).text)
                $temp = get-aduser -server ($WorkSheet.Cells.Item($zeile,4).text) ($WorkSheet.Cells.Item($zeile,$spalte).text) -Properties displayname,mail | select displayname,mail
                $object | Add-Member NoteProperty Displayname ($temp.displayname)
                $object | Add-Member NoteProperty Mail ($temp.mail)
                
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

$Users = Read-excel -sheetname "Tabelle1" -file "C:\_MBA\data\FireFox-chrome.xlsx"
$Users | export-csv -Path C:\_MBA\data\Users-with-firefox_Chrome.csv -Append -NoTypeInformation -Encoding UTF8