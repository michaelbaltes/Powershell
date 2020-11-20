$watch = [System.Diagnostics.Stopwatch]::StartNew()
$all = Get-EventLog -LogName Application
$watch.Stop()
$watch.ElapsedMilliseconds
$all.Count