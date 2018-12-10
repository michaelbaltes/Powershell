function Read-excel ($sheetname, $file) {
        # Object erstellen
        $objExcel = New-Object -ComObject Excel.Application
        $objExcel.Visible = $false
        # Datei anschnallen
        $WorkBook = $objExcel.Workbooks.Open($file)
    
        # welche mappen gibt es?
        $sheet =  ($WorkBook.sheets | Select-Object -Property Name).Name
        # $sheetname = $sheetname
        # Mappe öffnen
        $WorkSheet = $WorkBook.Worksheets.Item($sheetname)
    
        # Starte mit Zeile n
        [int]$spalte = 2 # Spalte B
        [int]$zeile = 1 # Zeile 1 enhält keine Überschrift
        $all = @()
        # $group = New-Object System.Collections.ArrayList
          
            do{
                #$WorkSheet.Cells.Item($zeile,$spalte).text
                #$WorkSheet.Cells.Item($zeile,3).text
                #$WorkSheet.Cells.Item($zeile,4).text
                #$WorkSheet.Cells.Item($zeile,6).text
                $object = New-Object psobject 
                $object | Add-Member NoteProperty Login ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty Mail ($WorkSheet.Cells.Item($zeile,3).text)
                $object | Add-Member NoteProperty SwissEduID ($WorkSheet.Cells.Item($zeile,4).text)
                $object | Add-Member NoteProperty VSPHID ($WorkSheet.Cells.Item($zeile,6).text)
                $zeile++ | Out-Null
                
                #$group.Add($WorkSheet.Cells.Item($zeile,$spalte).text)
                #$group.Add($WorkSheet.Cells.Item($zeile,3).text)
                #$group.Add($WorkSheet.Cells.Item($zeile,5).text)
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

    $all = $null
    $userTomigrate = $null
   $userTomigrate =  Read-excel -sheetname 'Rektorat (100)' -file 'I:\09 Projekte & Fachthemen\9.1 Projekte aktuell\9.12 Projekte ZV aktuell\future IT -fIT\03-KonzepteZurUmsetzung\1B-AD-Konzept&Namenskonvention\AlleUser-ausVSPH.xlsx'