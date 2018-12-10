# Object erstellen
$objExcel = New-Object -ComObject Excel.Application
$objExcel.Visible = $false
# Datei anschnallen
$WorkBook = $objExcel.Workbooks.Open("C:\_MBA\data\AlleUser-ausVSPH-doppeltemakiert.xlsx")

# welche mappen gibt es?
$sheet =  ($WorkBook.sheets | Select-Object -Property Name).Name
$sheetname  = "Alle Verwaltung"
# Mappe öffnen
$WorkSheet = $WorkBook.Worksheets.Item($sheetname)

# Starte mit Zeile n
[int]$spalte = 2 # Spalte B
[int]$zeile = 1 # Zeile 1 enhält (keine) Überschrift
$UserLoginName = New-Object System.Collections.ArrayList
    do{
        $WorkSheet.Cells.Item($zeile,$spalte).text
        $zeile++
        $UserLoginName.Add($WorkSheet.Cells.Item($zeile,$spalte).text)
    }
    while($WorkSheet.Cells.Item($zeile,$spalte).text.length -gt 0)
    #Write-Warning $zeile
    #COM-Objektes beenden
$objExcel.Quit()
#COM-Objektes aus dem Speicher entfernen
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)

try {
    foreach($user in $UserLoginName){
        $not = Get-ADUser -Filter * -Properties * | ?{$_.employeeType -ne "staff" }
        
    }
}
catch {
    Write-Warning -Message $user " not found!!!!"
}