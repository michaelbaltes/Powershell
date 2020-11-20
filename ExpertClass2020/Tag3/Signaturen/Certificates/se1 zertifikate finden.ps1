
$heute = Get-Date

# alle nicht-abgelaufenen persönlichen Code Signing Zertifikate finden
Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert |
  Where-Object { $_.NotAfter -ge $heute } |
  Select-Object -Property *

# alle abgelaufenen Zertifikate finden
Get-ChildItem -Path cert:\ -Recurse | 
  Where-Object { $_.NotAfter -ne $null } |
  Where-Object { $_.NotAfter -lt $heute } |
  Select-Object -Property Subject, NotAfter |
  Out-GridView