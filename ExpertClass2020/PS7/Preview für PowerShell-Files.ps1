$path = 'HKCU:\Software\Classes\.ps1'
$exists = Test-Path -Path $path
if (!$exists){
    $null = New-Item -Path $Path
}
$path = 'HKCU:\Software\Classes\.psd1'
$exists = Test-Path -Path $path
if (!$exists){
    $null = New-Item -Path $Path
}
$path = 'HKCU:\Software\Classes\.psm1'
$exists = Test-Path -Path $path
if (!$exists){
    $null = New-Item -Path $Path
}

Set-ItemProperty HKCU:\Software\Classes\.ps1 -Name PerceivedType -Value text



Get-Item HKCU:\Software\Classes\* -Include .ps1,.psm1,.psd1 | Set-ItemProperty -Name PerceivedType -Value text
