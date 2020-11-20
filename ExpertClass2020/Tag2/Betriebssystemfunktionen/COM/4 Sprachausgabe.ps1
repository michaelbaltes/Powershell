 # hier steht der Code zum Ausführen:
  $sapi = New-Object -ComObject Sapi.SpVoice
  
  $sapi.Rate = -10
  $sapi.Speak("Ich bin die kleine PowerShell, wusstest Du das?")