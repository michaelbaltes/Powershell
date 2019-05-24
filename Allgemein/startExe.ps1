# read model to get right file
$model = Get-WmiObject -Class win32_computersystem -Property model
$setting = $model.model -replace " " , "_"
$setting = $setting + ".txt"
$setting

# getting current path 
$path = Split-Path -Parent $PSCommandPath
$configpath = $path + "\config"

& "$path\BiosConfigUtility64.exe" /GetConfig:"$path\$setting"