
try
{
    ForEach($_ in (1..10)) 
    {

        throw "Mist"

    }
}
catch
{
    $global:test = $_
}
