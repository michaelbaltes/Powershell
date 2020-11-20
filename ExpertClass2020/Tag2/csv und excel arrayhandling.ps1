

Get-EventLog -LogName System -EntryType Error -Newest 10 |
  Select-Object -Property TimeWritten, Message, ReplacementStrings |
  ForEach-Object { 
      $_.ReplacementStrings = $_.ReplacementStrings -join ','
      $_.IPAddresses = $_.IPAddresses -join ','
      $_
  } |
  Export-Excel