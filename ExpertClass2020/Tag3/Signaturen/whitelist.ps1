$trusted = '8644EC568E0FFF6E91DD4DF9591970D284712C40', '8644EC568E0FFF6E91DD4DF9591970D284712C44', '05B7A10BE959AF38C4710A8BE3174CFFA6F95058'


Get-ChildItem -Path C:\Signaturen -Recurse -Filter *.ps1 -Include *.ps1 |
  Get-AuthenticodeSignature |
  Where-Object { 
    $_.Status -ne 'Valid' -or $_.SignerCertificate.Thumbprint -notin $trusted } |
    Where-Object {
      $_.Status -ne 'UnknownError' -or $_.SignerCertificate.Thumbprint -notin $trusted
    }

