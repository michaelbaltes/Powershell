Install-Module -Name QRCodeGenerator -Scope CurrentUser -Force

New-QRCodeVCard -Show -FirstName Tobias -LastName Weltner -Company psconf.eu -Email tobias@powershell.one

Get-Command -Name New-QRCodeVCard
Get-Command -Module QRCodeGenerator

New-QRCodeGeolocation -Show -Address 'Hauptbahnhof Hannover'
