function Test-ValidateSet
{
  param
  (
    [ValidateSet('NewYork','London','Berlin')]
    [string]
    $City = 'Undefined'
  )

  "Choice: $City"
}

# this works:
Test-ValidateSet -City Berlin

# this works:
Test-ValidateSet

# this fails:
Test-ValidateSet -City Hannover