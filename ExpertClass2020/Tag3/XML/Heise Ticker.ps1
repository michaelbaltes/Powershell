function Get-ExchangeRate
{
    $url  = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
    $xml = [xml]''

    $xml.Load($url)
    $xml.InnerXml
    $xml.Envelope.Cube.Cube.Cube
}


$url = 'https://www.heise.de/tr/rss/news-atom.xml'
$xml = [xml]''

$xml.Load($url)
$xml.InnerXml
$xml.Feed.entry | Foreach-Object {
    [PSCustomObject]@{
        Titel = $_.title.'#text'
        Artikel = $_.content.'#cdata-section'
        Link = $_.link.href
    }
} | Out-GridView -PassThru |
ForEach-Object {
    Start-Process $_.Link
}


