
trap
{
    "Ich habe empfangen $_"
    continue
}

class JürgException : Exception
{
    [int]$data = 123

}


try
{
    Get-Service zumsel -ErrorAction Stop

}
catch
{
    throw [System.DivideByZeroException]::new()
    throw ([JürgException]::new())
}

