

$eimer = 1..100000 | ForEach-Object { "liste$_" }
$eimer = 1..100000 | ForEach-Object -Process { "liste$_" }


$eimer = 1..100000 | . { process {  "liste$_"  } }


