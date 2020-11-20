function Test-Positional
{
  param
  (
    [Parameter(Position=0)]
    [String]
    $Name,

    [Int]
    $Id
  )

  # return all submitted parameters:
  $PSBoundParameters

}

Test-Positional -? | Out-String -Stream | Select-String Syntax -Context 0,2