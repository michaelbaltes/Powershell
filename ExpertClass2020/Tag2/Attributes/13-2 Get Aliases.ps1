function Get-ParameterAlias
{
  param
  (
    [String]
    [Parameter(Mandatory)]
    $CommandName
  )

  Get-Command -Name $CommandName |
    # read the parameters hashtable:
    Select-Object -ExpandProperty Parameters |
    # get all values from the hashtable:
    Select-Object -ExpandProperty Values |
    # dump alias information:
    Select-Object -Property Name, Aliases, ParameterType |
    # sort by name:
    Sort-Object -Property Name
}

Get-ParameterAlias -CommandName Get-Process