

$url = 'https://www.heise.de/tr/rss/news-atom.xml'
$xml = [xml]''
$xml.Load($url)
$xml.Save("$env:temp\test.xml")
$xml.feed.author.name = 'Tobias Weltner'
$xml.Save("$env:temp\test.xml")
