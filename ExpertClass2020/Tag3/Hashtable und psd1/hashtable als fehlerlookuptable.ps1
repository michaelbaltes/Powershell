

# zusatzinfos über hashtable

$prozesse = Get-Process

$zusatzInfos = @{}

$zusatzInfos[$prozesse[9].Id] = "hier sind die Zusatzinfos"


$hash = @{}
$hash.5675786758 = "Meldung 1"
$hash.34674 = 'Schlimmer Fehler'

$fehler = 346748
if ($hash.ContainsKey($fehler))
{
    $hash.$fehler
}
else
{
    "UNBEKANNT"
}

