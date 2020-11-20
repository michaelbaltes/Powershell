
$array = 1..1000

$ergebnis = foreach($_ in $array)
{
    "Wert $_"
    Start-Sleep -Milliseconds 200
} 


$ergebnis | Out-GridView