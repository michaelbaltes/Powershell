$command = {
  $sapi = New-Object -ComObject Sapi.SpVoice
  $sapi.Speak("My name is $env:username")
  }



$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)

"powershell.exe -encodedCommand $encodedCommand" | Set-ClipBoard


