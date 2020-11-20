

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
    
    Mitarbeiter([int]$Personalnummer, [string]$Name, [DateTime]$Datum)
    {
        $this.Name = $Name
        $this.Id = $Personalnummer
        $this.Datum = $Datum
    }
}

$meinMitarbeiter = [Mitarbeiter]::new(100, "Werner") 
$meinMitarbeiter
