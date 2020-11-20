

Import-Excel abc.xlsx | New-ADUser -AccountPassword { $_.AccountPassword | ConvertTo-SecureString -AsPlainText -Force }