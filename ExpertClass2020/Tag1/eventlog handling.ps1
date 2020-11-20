
Get-EventLog -LogName Security -InstanceId 4798 |
  ForEach-Object {
      [PSCustomObject]@{
          Time = $_.TimeGenerated
          LogonType = $_.ReplacementStrings[8]
          Process = $_.ReplacementStrings[9]
          Domain = $_.ReplacementStrings[1]
          User = $_.ReplacementStrings[0]
          Method = $_.ReplacementStrings[10]
          Source = $_.Source

      }
  } | Out-GridView

# ReplacementStrings im eventlog XML anschauen für die Reihenefolge und Liste der Einträge

  $a = Get-EventLog -LogName Security -InstanceId 4798 | Select-Object -First 5
  $a[0].ReplacementStrings


  $hashtable = @{
    LogName = 'Security'
    ID=4624
}
$A = Get-WinEvent -FilterHashtable $hashtable -MaxEvents 5 -Verbose
$a[0].Properties[6].Value