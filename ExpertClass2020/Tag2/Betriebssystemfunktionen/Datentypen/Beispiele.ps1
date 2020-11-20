

[version]'1.2.3.4'
[System.Net.Mail.MailAddress]'tobias@powershell.one'
[System.TimeSpan]100
[System.DateTime]'1.1.2000'

#region Explizit
$datum = [DateTime]'1.1.2000'
#endregion

#region Implizit
[DateTime]$datum = '1.1.2000'
$datum = '2.2.2000'
#endregion