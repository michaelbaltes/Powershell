
# liest ausschließlich .psd1 Dateien, die keine Befehle oder Variablen enthalten

Write-Warning $host.CurrentUICulture
Import-LocalizedData -BaseDirectory $PSScriptRoot -FileName sampledata2.psd1 -BindingVariable Data 


$data


