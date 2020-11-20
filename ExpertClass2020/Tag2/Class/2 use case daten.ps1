

class Mitarbeiter
{
    [int]$id = 123
    [string]$Name = 'Tobias'
    
    
}

$meinMitarbeiter = [Mitarbeiter]::new()
$meinMitarbeiter.id = 100
$meinMitarbeiter.Name = 'Tobias'
$meinMitarbeiter
