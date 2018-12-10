#Get-ADUser -Filter * -SearchBase "OU=ZV,OU=Users,OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local" -Properties DisplayName | % {Set-ADUser $_ -remove @{department="$_.department";departmentNumber="$_.departmentNumber";employeeType="$_.employeeType";extensionAttribute1="$_.extensionAttribute1";extensionAttribute2="$_.extensionAttribute2";employeeNumber="$_.employeeNumber"}}

foreach($user in (Get-ADUser -Filter "department -ne '<Nicht festgelegt>'" -Properties *)){
Write-Host "bearbeite : " $user.displayname

Set-ADUser $user -remove @{department="$user.department";departmentNumber="$user.departmentNumber";employeeType="$user.employeeType";extensionAttribute1="$user.extensionAttribute1";extensionAttribute2="$user.extensionAttribute2";employeeNumber="$user.employeeNumber"}
}



foreach($user in (get-aduser -Filter "name -eq 'PHBEMIC10551'" -SearchBase "OU=ZV,OU=Users,OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local" -Properties *))
{ 

write-host $user.mail
if($user.mail -ne $null){
set-aduser $user -UserPrincipalName $user.mail
}
}



# Computer Verwaltung
Get-ADComputer -Filter * -Properties Name,OperatingSystem,LastLogonDate,IPv4Address,CanonicalName,Description -SearchBase "OU=Clients,OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local" | export-csv -Path C:\_MBA\data\Computer-Verwaltung.csv -NoTypeInformation 

# Computer Verwaltung
Get-ADComputer -Server SRV-DC-007.phbecampus.phbern.local -Filter * -Properties Name,OperatingSystem,LastLogonDate,IPv4Address,CanonicalName,Description -SearchBase "DC=phbecampus,DC=phbern,DC=local" 