
function grep
{
  param
  (
    # filter string that must be present in object string representation
    [Parameter(Mandatory)]
    [string]
    $Filter,

    # data to be filtered
    [Parameter(ValueFromPipeline)]
    [object]
    $InputData
  )

  process
  {
    # check all properties for search filter
    $include = ($InputData | Out-String) -like "*$Filter*"
    # output original object if filter matched:
    if ($include) { $InputData }
  }
}

Get-Service | grep run
dir $env:windir  | grep 2020