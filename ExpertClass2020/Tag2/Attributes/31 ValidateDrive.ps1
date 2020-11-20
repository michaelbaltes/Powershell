# allow any path that starts with the defined drives:
[ValidateDrive('c','d','env')][string]$Path = 'c:\windows'

# works:
$Path = 'env:username'

# fails:
$Path = 'e:\test'