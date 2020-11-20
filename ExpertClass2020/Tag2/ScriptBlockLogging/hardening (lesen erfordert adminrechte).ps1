# Berechtigungen des Security Logs lesen
$sddlSecurity = ((wevtutil gl security) -like 'channelAccess*').Split(' ')[-1]

# auf PowerShell Log anwenden:
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\winevt\Channels\Microsoft-Windows-PowerShell/Operational"
Set-ItemProperty -Path $Path -Name ChannelAccess -Value $sddlSecurity

# wirksam nach Neustart des Dienstes
Restart-Service -Name EventLog -Force