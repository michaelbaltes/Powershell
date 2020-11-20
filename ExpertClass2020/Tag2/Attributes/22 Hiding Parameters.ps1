function Test-AdvancedFunction
{
  param
  (
    [Parameter(Mandatory)]
    [string]
    $Name,

    [Parameter(DontShow)]
    [Switch]
    $Dummy

  )
  Write-Verbose "VERBOSE OUTPUT"
}

# hides parameter from help and intellisense
# hides ALL COMMON PARAMETERS as well!
Get-Help Test-AdvancedFunction -Parameter *

# parameter is still accessible:
Test-AdvancedFunction -Dummy -Name test
Test-AdvancedFunction -Verbose -Name test