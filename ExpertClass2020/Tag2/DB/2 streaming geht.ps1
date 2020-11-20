
$array = 1..1000

& { foreach($_ in $array)
    {
        "Wert $_"
        Start-Sleep -Milliseconds 200
    }
} | Out-GridView