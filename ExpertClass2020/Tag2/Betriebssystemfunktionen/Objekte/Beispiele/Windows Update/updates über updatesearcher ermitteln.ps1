

$pattern = 'KB\d{6,9}'

$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$HistoryCount = $UpdateSearcher.GetTotalHistoryCount()
$UpdateSearcher.QueryHistory(1,$HistoryCount) | ForEach-Object {
  $kb = 'N/A'
  if ($_.Title -match $pattern) { $kb = $matches[0] }
  [PSCustomObject]@{
    KB = $kb
    Title = $_.Title
    Description = $_.Description
    AppId = $_.CLientApplicationID
  }
} 