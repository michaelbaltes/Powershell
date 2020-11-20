
try
{
    1..10 | ForEach-Object {

        throw "Mist"

    }
}
catch
{
    $global:test = $_
}
