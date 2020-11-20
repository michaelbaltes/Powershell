function Test-Positional
{
  [CmdletBinding(PositionalBinding=$false)]
  param
  (
    [string]
    $Name,

    [int]
    $Id
  )

  # return all submitted parameters:
  $PSBoundParameters
}

Test-Positional -? | Out-String -Stream | Select-String Syntax -Context 0,2
