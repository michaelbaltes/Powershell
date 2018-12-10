function get-all-member ($group) {
    
    foreach($groupname in $group){
    
        if($groupname -ne $null){
          
            write-host $groupname.name -BackgroundColor Cyan
            $prop = @{
                      Name = $groupname.name
                      Member = (Get-ADGroupMember -Server srv-dc-007 -Identity $groupname.distinguishedname | select samAccountName)
                      }
            #Get-ADGroupMember -Identity $groupname.distinguishedname | select samAccountName | Export-Csv -Path C:\_MBA\data\distribution.csv -NoTypeInformation -append
            $obj = New-Object psobject -Property $prop | Export-Csv -Path C:\_MBA\data\all-CampusGroups.csv -NoTypeInformation -append
        }
        else
        {
        #$groupname.name ; "_leer"| Export-Csv -Path C:\_MBA\data\distribution.csv -NoTypeInformation -append
        $prop = @{
                      Name = $groupname.name
                      Member = "_leer"
                      }
        $obj = New-Object psobject -Property $prop | Export-Csv -Path C:\_MBA\data\all-CampusGroups.csv -NoTypeInformation -append
        }
    }
}

$groups =  Get-ADGroup -Filter * -Server srv-dc-007 #{GroupCategory -eq "Distribution"}

get-all-member -group $groups