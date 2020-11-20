



$eimer = [System.Collections.ArrayList]@()
foreach($_ in (1..10000))
{
    $null = $eimer.Add("liste$_") # besser wegen dynamischen Liste
}

$eimer.count
