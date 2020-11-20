# typical use-case
[ValidateSet('Microsoft','Amazon','Google')]$customer = 'Microsoft'
# works
$customer = 'google'

# little-known use-case
[ValidateSet('Microsoft','Amazon','Google',IgnoreCase=$false)]$customer = 'Microsoft'
# fails
$customer = 'google'
