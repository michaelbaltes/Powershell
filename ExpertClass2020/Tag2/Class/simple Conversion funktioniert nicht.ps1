class MyProc : System.Diagnostics.Process
{
    [int]$myInfo = 0
}

$proc = Get-Process -id $pid
[MyProc]$newproc = $proc