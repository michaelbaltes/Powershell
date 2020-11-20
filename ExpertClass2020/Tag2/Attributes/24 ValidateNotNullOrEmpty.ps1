# this variable cannot store empty strings
[ValidateNotNullOrEmpty()][string]$Path = 'c:\somefolder'
# this fails:
$Path = ""