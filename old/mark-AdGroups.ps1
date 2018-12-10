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
                $object | Add-Member NoteProperty OldName ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty NewName ($WorkSheet.Cells.Item($zeile,3).text)
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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Variables Control before start script ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~# **************************************************************************************************************************
$ExcelContent = Read-excel -sheetname "Tabelle1" -file "C:\_MBA\data\VerteilergruppenVerwaltung.xlsx"
$Server = "srv-dc-004.verwaltung.phbern.local"
$OutputFile = "C:\_MBA\data\ADMT\VerteilergruppenVerwaltung.csv"
# **************************************************************************************************************************

$AllGroups = @()

foreach($localG in $ExcelContent)
{
    if ($localG.newName -ne $null)
    {
        $o = $localG.OldName
        # Extend old groups with infos
        Get-ADGroup -Server $Server -filter {name -eq $o} | Set-ADGroup -replace @{extensionAttribute1=$localG.newname;extensionAttribute2=$localG.oldName}

        # create object for csv export to migrate with ADMT
        $Groupobject = New-Object psobject
        $Groupobject | Add-Member NoteProperty SourceName ($localG.OldName)
        $Groupobject | Add-Member NoteProperty TargetRDN ("CN=" + $localG.NewName)
        $Groupobject | Add-Member NoteProperty TargetUPN ($localG.NewName)

        $AllGroups += $Groupobject
    }
}

# Export groups to csv
$AllGroups | export-csv -Path $OutputFile -NoTypeInformation -Encoding UTF8