Install-Module -Name ImportExcel -Scope CurrentUser -Force
Install-Module -Name PSWriteHTML -Scope CurrentUser -Force


# excelreport
$daten = Get-EventLog -LogName System -EntryType Error, Warning -Newest 5 | 
   Select-Object -Property TimeGenerated, Message 
   
$daten |
   Export-Excel -Show


# htmlreport
$path = "$env:temp\report.html"
$tabelle = { New-HTMLTable -DataTable $daten }
New-HTML -HtmlData $tabelle -FilePath $path -ShowHTML -TitleText 'Fehler' -Online

