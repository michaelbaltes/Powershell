
$h = @{
  Name = 'Superzeit'
  Expression = { Get-Date -Date $_.TimeWritten -Format 'yyyy-MM-dd HH:mm:ss ffff'  }

}

Get-EventLog -LogName System -Newest 10 |
  Select-Object -Property Index, $h, EntryType, Source
  