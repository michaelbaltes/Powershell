

Get-CimInstance -ClassName win32_LogicalDisk |
  Select-Object -Property DeviceID, Size |
  ForEach-Object { 
      $_.Size = [Math]::Round( ($_.Size / 1MB),2) 
      $_
  }
# größe in MB, gerundet auf eine Nachkommastelle
[Math]::Round(453.4578924398243,1)
[Math]::Floor(5.9)
[Math]::Round('a1287',1)

[Convert]::ToString(77,16)
[Convert]::ToInt64('af',16)
