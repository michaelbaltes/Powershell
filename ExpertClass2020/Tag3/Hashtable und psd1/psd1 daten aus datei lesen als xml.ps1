#requires -Version 5.0 

# liest ausschließlich .psd1 Dateien, die keine Befehle oder Variablen enthalten

$path = "$PSScriptRoot\sampledata.psd1"
$infos = Import-PowerShellDataFile -Path $path



#[PSCustomObject]$infos | ConvertTo-Xml