

class Mitarbeiter
{
    [int]$id = 123
    [string]$Name = 'Tobias'
    [DateTime]$Datum
    
    Mitarbeiter([int]$Personalnummer, [string]$Name)
    {
        $this.Name = $Name
        $this.Id = $Personalnummer
    }
}

$meinMitarbeiter = [Mitarbeiter]::new(100, "Werner") 
$meinMitarbeiter
