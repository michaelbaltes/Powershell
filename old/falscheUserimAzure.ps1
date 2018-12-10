$user = Get-ADUser -Filter 'Name -notlike "*.*"' -Properties * -SearchBase "OU=USR-Verwaltung,OU=PHBern,DC=intra,DC=phbern,DC=ch" | select samAccountname, mail # | out-file C:\_MBA\data\IntraUser.txt -Append # UserPrincipalName, extensionAttribute1, extensionAttribute2, employeeType, departmentnumber, department # INTRA
if($user.mail -notlike "*@*")
    {
     $user | out-file C:\_MBA\data\IntraUser-LOESCHEN.txt
    }
else
    {
     $user = $user.samAccountname -replace '\s', ''
     $user | out-file C:\_MBA\data\IntraUser.txt
    }