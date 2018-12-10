$VGA = Get-Content C:\_MBA\data\VGA.txt
foreach ($user in $VGA)

    {
    $u = Get-ADUser $user -Properties * | select displayname,  CN, EmailAddress, UserPrincipalName 
    $u
    #Set-ADUser $user -UserPrincipalName $u.EmailAddress
    #Get-ADUser $user -Properties * | select displayname,  CN, EmailAddress, UserPrincipalName 
    }