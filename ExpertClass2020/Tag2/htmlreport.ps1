
Install-Module -Name PSWriteHTML -Scope CurrentUser -Force
$path = "$env:temp\report.html"

$daten = Get-Process
$tabelle = { New-HTMLTable -DataTable $daten }
New-HTML -HtmlData $tabelle -FilePath $path -ShowHTML -TitleText 'Prozesse' -Online