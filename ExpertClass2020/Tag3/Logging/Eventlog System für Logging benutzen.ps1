#region vorbereitung als admin
New-EventLog -LogName RealStuff -Source Installation, Wartung
Limit-EventLog -LogName RealStuff -MaximumSize 100MB -OverflowAction OverwriteAsNeeded
Get-EventLog -List
#endregion


Write-EventLog -LogName RealStuff -Source Installation -EntryType Error -Message 'Etweas fürchterliches geschah' -EventId 7568 
Get-EventLog -LogName RealStuff -Newest 2 -Message *fürcht* -After '2020-10-01 09:00'

Show-EventLog

