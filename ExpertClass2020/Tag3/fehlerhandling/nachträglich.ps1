
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


$logs = dir c:\windows -Filter *.log -Recurse -ErrorAction SilentlyContinue -ErrorVariable abc

$abc.Count
$abc.CategoryInfo | Select-Object Category, TargetName
$abc | Get-ErrorDetail | Out-GridView