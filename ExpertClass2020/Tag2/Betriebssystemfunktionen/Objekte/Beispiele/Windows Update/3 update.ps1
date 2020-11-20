$Session = New-Object -ComObject Microsoft.Update.Session
$Searcher = $Session.CreateUpdateSearcher()
$HistoryCount = $Searcher.GetTotalHistoryCount()
$Searcher.QueryHistory(1,$HistoryCount) | 
  Select-Object Date, Title, Description, SupportUrl |
  Out-GridView -Title 'Select one!' -OutputMode Single |
  ForEach-Object { Start-Process -FilePath $_.SupportUrl } |
  Out-GridView