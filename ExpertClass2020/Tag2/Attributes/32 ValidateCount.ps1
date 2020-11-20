function Test-Input
{
  param
  (
    [Parameter(Mandatory)]
    # allow a maximum of 3 strings:
    [ValidateCount(1,3)]
    [string[]]
    $ComputerName
  )

  # return arguments:
  $PSBoundParameters
}

# works:
Test-Input -ComputerName server12

# works:
Test-Input -ComputerName server12, dc1, dc2

# fails (too few):
Test-Input -ComputerName @()

# fails (too many):
Test-Input -ComputerName server12, dc1, dc2, dc3