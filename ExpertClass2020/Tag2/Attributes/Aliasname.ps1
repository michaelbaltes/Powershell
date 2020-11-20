

function Meins
{
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $alles,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('DirectoryName','Name')]
        $x
    )

    Process
    {
      $x

    }
}


#dir -File -recurse | Meins
Get-Process | Meins