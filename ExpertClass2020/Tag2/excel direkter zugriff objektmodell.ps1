

$Path = "$env:temp\liste.xlsx"
Get-ChildItem -Path c:\windows | Export-Excel -Path $Path -WorksheetName Dateien -Show

$ergebnis = Import-Excel -Path $Path -WorksheetName Dateien
$excel = Export-Excel -Path $Path -PassThru
$excel.Workbook.Worksheets