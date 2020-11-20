--> bad:
Import-Csv '.\Users.csv' | ForEach-Object { Get-ADUser -Filter {UserPrincipalName -eq $_.Email}}

--> OK:
Import-Csv '.\Users.csv' | ForEach-Object {$Email = $_.Email; Get-ADUser -Filter {UserPrincipalName -eq $Email}}

Import-Csv '.\Users.csv' | ForEach-Object {$obj = $_; Get-ADUser -Filter {UserPrincipalName -eq $obj.Email}}


$a = 1
$code = { $a }.GetNewClosure()
& $code
$a = 2
& $code

Get-ADUser -Filter { }
Get-ADUser -LDAPFilter '(&(name=a*)(email=*)(!mobile=*))'