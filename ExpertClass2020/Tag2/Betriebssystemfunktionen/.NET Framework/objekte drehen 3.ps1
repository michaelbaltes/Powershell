
function ConvertObject-ToHash
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        $object
    )

    process
    {
    $object | 
        Get-Member -MemberType *Property | 
        Select-Object -ExpandProperty Name |
        ForEach-Object { $hash = @{}} { $hash[$_] = $object.$_ } { $hash } 
    }
}

systeminfo.exe /FO CSV | ConvertFrom-Csv | ConvertObject-ToHash | Out-GridView


