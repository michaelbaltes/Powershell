# Object erstellen
$objExcel = New-Object -ComObject Excel.Application
$objExcel.Visible = $false
# Datei anschnallen
$WorkBook = $objExcel.Workbooks.Open("I:\09 Projekte & Fachthemen\9.1 Projekte aktuell\9.12 Projekte ZV aktuell\future IT -fIT\03-KonzepteZurUmsetzung\1B-AD-Konzept&Namenskonvention\FilePermissionListe.xlsx")

# welche mappen gibt es?
$sheet =  ($WorkBook.sheets | Select-Object -Property Name).Name
$sheetname  = "Tabelle3"
# Mappe öffnen
$WorkSheet = $WorkBook.Worksheets.Item($sheetname)

# Starte mit Zeile n
[int]$spalte = 2 # Spalte B
[int]$zeile = 2 # Zeile 1 enhält die Überschrift
$group = New-Object System.Collections.ArrayList
    do{
        $WorkSheet.Cells.Item($zeile,$spalte).text
        $zeile++
        $group.Add($WorkSheet.Cells.Item($zeile,$spalte).text)
    }
    while($WorkSheet.Cells.Item($zeile,$spalte).text.length -gt 0)
    #Write-Warning $zeile
    #COM-Objektes beenden
$objExcel.Quit()
#COM-Objektes aus dem Speicher entfernen
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)