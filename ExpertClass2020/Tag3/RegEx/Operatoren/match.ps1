


if ("Das Problem liegt in KB4366843 und ist doof." -match 'KB\d{6,8}')
{
    $matches[0]
}
else
{
    Write-Warning "Keine KB Nummer"
}