
$payload = "Geheim"
$bytes = [System.Text.Encoding]::Unicode.GetBytes($payload)
$encodedCommand = [Convert]::ToBase64String($bytes)
$encodedCommand

$bytes = [System.Convert]::FromBase64String($encodedCommand)
[System.Text.Encoding]::Unicode.GetString($bytes)