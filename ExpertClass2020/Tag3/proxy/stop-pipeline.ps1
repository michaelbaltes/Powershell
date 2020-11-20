


1..1000000 | ForEach-Object { if ($_ -eq 20) { $_ } } | Select-Object -First 1

function Stop-Pipeline
{
    $pipeline = { Select-Object -First 1 }.GetSteppablePipeline()
    $pipeline.Begin($true)
    $pipeline.Process($true)
    $pipeline.End()
}


1..1000000 | ForEach-Object { if ($_ -eq 20) { 
    $_
    Stop-Pipeline } } 