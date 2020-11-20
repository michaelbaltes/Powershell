# variable $name can store any string:
[string]$name = 'Tobias'

# variable $customer can store only the strings defined by the attribute
[string][ValidateSet('Microsoft','Amazon','Google')]$customer = 'Microsoft'
$customer = 'Amazon'
$customer = 'Google'

# when you assign a string that is not defined by the attribute,
# an exception is raised:
$customer = 'Tesla'