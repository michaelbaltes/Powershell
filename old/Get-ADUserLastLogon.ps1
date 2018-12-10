$lastdate = (Get-Date).AddDays(-100)
$filter = {lastLogon -lt $lastdate}
Get-AdUser -Filter $filter -Property lastlogondate | sort-object -property lastlogon -descending | select name, lastlogondate | export-csv C:\_MBA\data\UserLastLogon.csv


get-aduser -Filter * -Properties homemdb | ?{$_.homemdb -notlike "CN=*"} | export-csv -Path C:\_MBA\data\noEmail-Verwaltung.csv -Encoding UTF8 -NoTypeInformation