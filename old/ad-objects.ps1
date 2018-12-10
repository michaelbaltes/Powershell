function get-groups ($category, $scope, $nameonly,$namefilter,$searchBase) {
    $gruppen = Get-ADGroup -filter "Groupcategory -eq $category -AND GroupScope -eq $scope -AND Name -like '$namefilter'" -SearchBase $searchBase
    foreach ($gg in $gruppen){ 
     
     if($gg.DistinguishedName -match "OU=Verwaltung"){
        # Write-Host "Exporting $($_.name)" -ForegroundColor Cyan
        $name = $gg.name -replace " ","-"
     }
     if ($nameonly){
     return $name} else {
         return $gruppen
     }
    }
}

# get all global groups under Verwaltung OU
$all_Globalgroups = get-groups -category "'Security'" -scope "'Global'" -nameonly $false -namefilter '*' -searchBase "OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local"

$myglobalGroupmember = @()
foreach($g in $all_Globalgroups)
    {
      #$tmpGroup = $g.DistinguishedName  
      foreach ($member in (Get-ADGroupMember -Identity $g.DistinguishedName))
      {
        
        $myglobalGroupmember +=   New-Object psobject -Property @{
        Groupname = $g.name
        Member = $member.name
        Klassifikation = $member.objectClass
        }

      }

    }   
    