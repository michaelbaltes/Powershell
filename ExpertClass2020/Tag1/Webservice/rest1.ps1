Invoke-RestMethod -Uri https://blogs.msdn.microsoft.com/powershell/feed/ |
  Select-Object -Property Title, pubDate |
  Out-GridView

  #Format-Table -Property Title, pubDate