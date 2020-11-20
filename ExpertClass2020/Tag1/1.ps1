


1..10000 | ForEach-Object { "liste$_" }


$eimer = @()
foreach($_ in (1..10000))
{
    $eimer += "liste$_"  # sehr langsam
}

$eimer.count
