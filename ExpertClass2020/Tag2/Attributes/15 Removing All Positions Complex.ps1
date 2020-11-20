function Test-Positional
{
  [CmdletBinding()]
  param
  (
    [Parameter(ParameterSetName='Dummy')]
    [string]
    $Name,

    [Parameter(ParameterSetName='Dummy')]
    [int]
    $Id
  )

  # return all submitted parameters:
  $PSBoundParameters
}

Test-Positional -? | Out-String -Stream | Select-String Syntax -Context 0,2