# allow any path that starts with the defined drives:
[ValidateScript({ Test-Path -Path $_ -PathType Leaf } )][string]$Path = 'c:\windows\explorer.exe'

# works:
$Path = (Get-Process -Id $pid).Path

# fails (does not exist):
$Path = 'e:\doesnotexist.txt'

# fails (is no file):
$Path = 'c:\windows'