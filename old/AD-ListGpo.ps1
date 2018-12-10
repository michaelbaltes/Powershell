#Get all OU Names Verwaltung
$dnV = Get-ADOrganizationalUnit -Filter * | Select -expand DistinguishedName 
foreach($OU in $dnV){
    
    $GPOName = $OU | Get-GPInheritance | Select-Object -expand gpolinks | ForEach-Object {get-gpo -domain "Verwaltung.phbern.local" -GUID $_.gpoid}
    
    #Write-Host | foreach {$GPOName}

    foreach($i in $GPOName){
        #Write-Host "OU-Name: " $OU
        #Write-Host "GPO-Name: " $GPOName.DisplayName
        #$GPOName.DisplayName | export-csv -Path C:\_MBA\data\gp.csv -Append
       # $ou.ToString(), $i.DisplayName | export-csv -Path C:\_MBA\data\gp.csv -Append
       $ou + ";" + $i.DisplayName | Out-File -FilePath C:\_MBA\data\gp.txt -Append
       
    }
    
}
# Get Computer
Get-ADComputer -Server srv-dc-008.phbecampus.phbern.local -Filter * -Properties * | export-csv -Path C:\_MBA\data\AdComp-Campus.csv

# Get Groups
Get-ADGroup -Server srv-dc-008.phbecampus.phbern.local -Filter * | measure

Get-ADGroup -Server srv-dc-003.verwaltung.phbern.local -Filter * | measure

