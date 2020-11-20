

class RealStuff
{
    [int]$id = 123
    [string]$Name = 'Tobias'
    

    [int]Multiply([int]$wert1, [int]$wert2)
    {
        return $wert1*$wert2
    }
    
    [void]TuWas()
    {
        Write-Host "Huhu!"
    }
    
}

$meinObjekt = [RealStuff]::new()
$meinObjekt.Multiply(3,7)
$meinObjekt.TuWas()

