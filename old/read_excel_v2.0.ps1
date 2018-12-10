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
                $object | Add-Member NoteProperty NewName ($WorkSheet.Cells.Item($zeile,2).text)
                $object | Add-Member NoteProperty Notes ($WorkSheet.Cells.Item($zeile,3).text)
                
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

$LocalGroupnames = Read-excel -sheetname "Migrationsliste" -file "C:\_MBA\data\Migrationsliste.xlsx"
<#
foreach($globalG in $GlobalGroupnames){
if ($globalG.newName -like "G-*"){
$o = $globalG.OldName
Get-ADGroup -filter {name -eq $o} | Set-ADGroup -Add @{extensionAttribute1=$globalG.newname}
}

}
#>
<# Clear old entries

foreach($group in $LocalGroupnames){

    $currentgroup = Get-ADGroup $group.oldname -properties * 
    if ($currentgroup.extensionAttribute1 -eq $group.newname)
        {
        if ($currentgroup.notes -ne $null)
            {
            $currentgroup | Set-ADGroup -Clear notes
            }
        }
     else
        {
         $currentgroup | Set-ADGroup -Clear extensionAttribute1  
        }
}
#>

# write all vaulues from excel to AD
<#
foreach($group in $LocalGroupnames)
{
    if($group.Notes -ne "")
        {
        Get-ADGroup $group.oldname | Set-ADGroup -Add @{extensionAttribute1=$group.newname; info=$group.notes}
        }
    else
        {
        Get-ADGroup $group.oldname | Set-ADGroup -Add @{extensionAttribute1=$group.newname}
        }
}
#>
foreach($group in $LocalGroupnames)
    {
    Get-ADGroup $group.oldname | Set-ADGroup -Add @{extensionAttribute2=$group.oldname}
    }