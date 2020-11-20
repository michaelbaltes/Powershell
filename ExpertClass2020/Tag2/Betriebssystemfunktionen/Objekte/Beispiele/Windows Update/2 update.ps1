Get-EventLog  -LogName System -InstanceId 19  |
  ForEach-Object {
    [PSCustomObject]@{
        Time = $_.TimeGenerated
        Update = $_.ReplacementStrings[0]
    }
  } | Out-GridView
