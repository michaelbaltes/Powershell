# define the legal string values
[ValidateSet('NewYork','London','Berlin')][string]$City = 'Berlin'

# this works:
$city = 'Berlin'

# this fails:
$city = 'Hannover'