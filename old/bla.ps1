<# $GP = Get-Content -Path C:\_MBA\data\GP-Verwaltung.txt
foreach($i in $GP)
{
get-aduser -Filter {UserPrincipalName -eq $i} -Properties DisplayName  | % {$_ |select DisplayName | Out-File C:\_MBA\data\GP-Verwaltung-Display.txt -Append}
}
write-host "hello" #>


#get-aduser -Filter * -SearchBase "OU=CampusUsers,OU=Users,OU=PHBECampus,DC=phbecampus,DC=phbern,DC=local" -Server srv-dc-007 -Properties lastlogondate  | export-csv -Path C:\_MBA\data\LastLogon-Campus.csv -Append -NoTypeInformation -Encoding UTF8
# %{
    #set-aduser $_.SamAccountName -clear description, department
#     set-aduser $_.SamAccountName -Replace @{title="staff (NMS)"}
# }
<# foreach ($pc in (Get-Content -Path C:\_MBA\data\015_freitag_campus.csv)) {

    &PING.EXE $pc | out-grid
}
 #>
$all = $null
$i = $null
$all= Import-Csv -Path C:\_MBA\data\new-attributes.csv 
foreach ($user in $all)
{
    if ($user.PLZ -ne "" -and $user.Telefonnummer -ne "" -and $user.Raum -ne "" -and $user.Funktion -ne "" -and $user.Stasse -ne "" -and $user.Stadt -ne "" )
   # if ($user.LoginName -eq "PHBEMIC10551" -and $user.Telefonnummer -ne "")
    {
        #$user | select LoginName, PLZ
       
        $i ++
        Write-host "bearbeite Account Nummer: $i User: "  $user.LoginName 
        set-aduser $user.LoginName -Clear physicalDeliveryOfficeName,telephoneNumber,description,postalCode,streetAddress,l,company
        set-aduser $user.LoginName -replace @{physicalDeliveryOfficeName=$user.Raum;telephoneNumber=$user.Telefonnummer;description=$user.Funktion;postalCode=$user.PLZ;streetAddress=$user.Stasse;l=$user.stadt}
    }

}
