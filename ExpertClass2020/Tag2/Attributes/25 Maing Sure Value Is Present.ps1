function Test-Input
{
  param
  (
    [Parameter(Mandatory)]
    [string]
    $UserName
  )

  "You entered $UserName"
}

# this works:
Test-Input -UserName Tobias
# this fails:
Test-Input -UserName ""