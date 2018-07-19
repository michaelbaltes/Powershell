
        # AllGroups list
        $allgroups = @()

        # current Object
        $groupobject = @{
        Grouptype = ""
        Groupname = ""
        Member = ""
        }



        # foreach ($group in (Get-ADGroup -Filter "extensionAttribute1 -notlike '*' -and GroupScope -eq 'Global'"))
        foreach ($group in (Get-ADGroup -Filter * -Server srv-dc-007))
        {
            if ((Get-ADGroupMember -Identity $group.SamAccountName -Server srv-dc-007) -eq $null){
                $groupobject.grouptype = $group.GroupScope
                $groupobject.groupname = $group.SamAccountName
                $groupobject.member = "_leer"        
                $object = New-Object PSObject -Property $groupobject
                $allgroups += $object
                }
                else
                {
                   foreach($member in (Get-ADGroupMember -Identity $group.SamAccountName -Server srv-dc-007))
                        {
                        $groupobject.grouptype = $group.GroupScope
                        $groupobject.groupname = $group.SamAccountName
                        $groupobject.member = $member.SamAccountName         
                        $object = New-Object PSObject -Property $groupobject
                        $allgroups += $object
                        }
                    }
        
        
        
        }
        $allgroups | Export-Csv -Path C:\_MBA\data\all-CampusGroups.csv