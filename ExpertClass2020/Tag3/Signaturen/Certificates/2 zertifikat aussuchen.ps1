
$heute = Get-Date

# Alternative: aus Datei laden:
#$cert = Get-PfxCertificate -FilePath c:\test.pfx

# alle nicht-abgelaufenen persönlichen Code Signing Zertifikate finden
$cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert |
  Where-Object { $_.NotAfter -ge $heute } |
  Out-GridView -OutputMode Single -Title 'Mit welchem Zertifikat soll signiert werden?'

if ($cert -eq $null) 
{ 
  Write-Warning 'Kein Zertifikat angegeben, Abbruch!'  
  return 
  }

Get-ChildItem -Path C:\Signaturen -Recurse -Filter *.ps1 -Include *.ps1 |
  Set-AuthenticodeSignature -Certificate $cert -TimestampServer 'http://timestamp.verisign.com/scripts/timstamp.dll'
  
