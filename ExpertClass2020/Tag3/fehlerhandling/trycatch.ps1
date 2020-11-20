
filter Get-ErrorDetail
{
    [PSCustomObject]@{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
    }

}



& {
    $ErrorActionPreference = 'Stop'

    try
    {
    
        2/0
        stop-service -name zumsel -ErrorAction Stop
    }
    catch [System.DivideByZeroException]
    {
        
    
        $_ | Get-ErrorDetail
    
    }
    catch [Microsoft.PowerShell.Commands.ServiceCommandException]
    {
        $_ | Get-ErrorDetail
    }
    catch
    {
        Write-Warning "Unbekannter Fehler: $_"
    }

}