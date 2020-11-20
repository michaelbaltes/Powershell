# https://github.com/lwsrbrts/PoSHue

#Install-Module -Name PoSHue -Scope CurrentUser
import-module poshue

$bridge = [HueBridge]::FindHueBridge() | Where-Object { $_.FriendlyName -like 'BridgeWork*' }
$bridge