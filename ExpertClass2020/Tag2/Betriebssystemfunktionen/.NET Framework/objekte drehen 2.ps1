
function ConvertObject-ToHash
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        $object,

        [string]
        $PropertyName = "Property",

        [string]
        $ValueName = "Value"
    )

    process
    {
    $object | 
        Get-Member -MemberType *Property | 
        Select-Object -ExpandProperty Name |
        Sort-Object |
        ForEach-Object { [PSCustomObject]@{ 
            $PropertyName = $_
            $ValueName = $object.$_} 
        }
    }
}

Get-ComputerInfo | ConvertObject-ToHash | Out-GridView
Get-WmiObject -Class Win32_BIOS | ConvertObject-ToHash -PropertyName Information -ValueName Data | Out-GridView

