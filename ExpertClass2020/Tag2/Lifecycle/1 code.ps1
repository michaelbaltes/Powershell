$Rate = 0
$Text = 'Ihr System wird heruntergefahren'


$sapi = New-Object -ComObject Sapi.SpVoice
$sapi.Rate = $Rate
$sapi.Speak($Text)
