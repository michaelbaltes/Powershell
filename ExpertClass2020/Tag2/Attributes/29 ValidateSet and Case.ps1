# define the legal string values (case-sensitive)
[ValidateSet('NewYork','London','Berlin', IgnoreCase=$false)][string]$City = 'Berlin'

# this works:
$city = 'Berlin'

# this fails because casing is not correct:
$city = 'berlin'