

class Mitarbeiter
{
    [int]$id = 123
    [string]$Name = 'Tobias'
    [DateTime]$Datum
    
    [void]AddDetails([int]$Personalnummer, [string]$Name)
    {
        $this.Name = $Name
        $this.Id = $Personalnummer
    }
    Mitarbeiter([int]$Personalnummer, [string]$Name)
    {
        $this.AddDetails($Personalnummer, $Name)
    }
    
    Mitarbeiter([int]$Personalnummer, [string]$Name, [DateTime]$Datum)
    {
       $this.AddDetails($Personalnummer, $Name)
        $this.Datum = $Datum
    }
}

[Mitarbeiter]::new(100, "Werner") 
[Mitarbeiter]::new(100, "Werner", (Get-Date)) 


