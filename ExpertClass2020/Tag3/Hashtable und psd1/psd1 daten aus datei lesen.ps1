#Requires -Version 5.0 -Modules test -RunAsAdministrator

# liest ausschließlich .psd1 Dateien, die keine Befehle oder Variablen enthalten

$path = "$PSScriptRoot\sampledata.psd1"
# $path = "c:\test\daten.psd1"
$infos = Import-PowerShellDataFile -Path $path 


$infos.Datum
$infos.ID 
