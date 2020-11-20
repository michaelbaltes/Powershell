



$eimer = [System.Collections.Generic.List[string]]@() # Typerisierung mit dynamischer Liste
foreach($_ in (1..10000))
{
    $eimer.Add("liste$_")
}

$eimer.count
