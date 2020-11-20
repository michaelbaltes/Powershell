


$computername = 'muckelsoft.com'

try
{
    1/0
    [System.Net.DNS]::GetHostEntry($computername)
}
catch [System.Net.Sockets.SocketException], [System.ArithmeticException]
{
    [Management.Automation.ErrorRecord]$e = $_

    $info = [PSCustomObject]@{
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
    }
    
    $info
}


