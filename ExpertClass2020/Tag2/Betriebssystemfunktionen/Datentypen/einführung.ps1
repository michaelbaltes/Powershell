
# PowerShell Host Priorität ändern
# $pid enthält eigene Process-ID
$prozess = Get-Process -Id $pid
$prozess.PriorityClass = 'BelowNormal'

$prozess.PriorityClass = 'Normal'

# nicht machen:
#Stop-Process -id $pid

# Datei anlegen
$Path = "$env:temp\dingens.txt"
"Hallo" | Out-File -FilePath $Path

# Zugriff auf Low-Level-Dateieigenschaften und -methoden
$datei = Get-Item -Path $Path
$datei.LastWriteTime
$datei.LastWriteTime = '1812-03-12 19:22:11'
$datei.Encrypt()
$datei.Decrypt()
$datei.Attributes += 'Hidden'
$datei.Attributes -= 'Hidden'
$datei.GetType().FullName
# anzeigen aller Eigenschaften und Methoden
$datei | Get-Member

# statische Member eines Datentyps:
[DateTime]::FromFileTime(6423767468734678)
[System.Net.Dns]::GetHostEntry

# Liste aller Objektmember (Typ als einer  unter vielen)
[System.Net.Dns] | Get-Member
[System.Net.Dns].Assembly.Location
# Liste aller eigenen Member (Einzigartiger Typ)
[System.Net.Dns] | Get-Member -Static
[System.Net.Dns]::GetHostEntry('microsoft.com')


$a = Get-Service -name Spooler
# benötigt adminrechte und einen dienst, der damit etwas anzufangen weiss:
(Get-Service -name Spooler).ExecuteCommand(8)