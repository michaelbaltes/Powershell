$pattern = 'KB\d{6,9}'

$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsInstalled=1").Updates)
$Updates | ForEach-Object {
  $kb = 'N/A'
  if ($_.Title -match $pattern) { $kb = $matches[0] }
  [PSCustomObject]@{
    KB = $kb
    Title = $_.Title
  }
} 