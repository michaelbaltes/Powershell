
# zivilisiert:
$url  = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'

Invoke-WebRequest -Uri $url -UseBasicParsing

Invoke-RestMethod -Uri $url -UseBasicParsing

# low level
[xml]$xml = ''
$xml = [xml]''

$xml.Load($url)
$xml.InnerXml
$xml.Envelope.Cube.Cube.Cube