

Get-WmiObject -Class Win32_Process -Filter 'name="explorer.exe"' |
  ForEach-Object {
      $result = $_.GetOwner()
      '{0}\{1}' -f $result.Domain, $result.User
  } | Sort-Object -Unique
  


Get-CimInstance -Class Win32_Process -Filter 'name="explorer.exe"' |
  ForEach-Object {
      $result = Invoke-CimMethod -MethodName GetOwner -InputObject $_
      '{0}\{1}' -f $result.Domain, $result.User
  } | Sort-Object -Unique
  
