

Get-Content -Path "C:\Users\tobia\OneDrive\Dokumente\Kurse\ExpertClass2020\Tag3\Logging\log.log" -Tail 0 -Wait | 
Where-Object { $_ -like 'ALARM*' } |
ForEach-Object {
    Write-Host "ALARM!"
}