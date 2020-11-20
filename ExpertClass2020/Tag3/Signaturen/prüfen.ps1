

dir -Path C:\Users\tobia\OneDrive\Dokumente\Kurse\ARAG1\Tag3 -Recurse -Filter *.ps1 |
  Get-AuthenticodeSignature |
  Where-Object { $_.Status -eq 'HashMismatch' -or $_.Status -eq 'UnknownError' } 