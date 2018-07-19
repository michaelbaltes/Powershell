
# Eingabe des INTRA Admin Benutzers admxyz@phbern.ch
# **************************************************
$cred = Get-Credential
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://s-prd-exch-001.intra.phbern.ch/powershell/ -Authentication Kerberos -Credential $cred

# Starting Remote Session
Import-PSSession $session

# Run Exchange Commands
# **************************************************

# Erzeugen einer Mailbox im Exchange PHBern (Mitarbeiter)
    enable-mailbox "MAIL-Adresse"

# Erzeugen einer Mailbox im Exchange Online O365 (Studierende)vorname.nachname@phbern365.mail.onmicrosoft.com
    Enable-RemoteMailbox "samAccoutName" -RemoteRoutingAddress "MAIL-Adresse O365 Addresse"

# Remove Remote Session
Remove-PSSession $session