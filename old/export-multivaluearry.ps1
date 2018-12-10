Get-ADUser -Filter * -Properties * | ?{$_.employeeType -ne "staff" } | select name, SamAccountName,DisplayName,DistinguishedName,@{Name='Memberof'; Expression={$_.memberof -join “;”}} | Export-Csv -Path C:\_MBA\data\NotmigratedUsers.csv -NoTypeInformation -Encoding UTF8



