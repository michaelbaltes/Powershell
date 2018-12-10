function Get-permissionOnFiler () {
   # foreach ($gruppe in (get-groups -category "'Security'" -scope "'Global'" -nameonly $false -namefilter '*' -searchBase "OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local")){
    #$g = "VERWALTUNG\" + $gruppe
    #-Exclude "\\srv-file-001\Users\IHP\Forschung\Forschung allg."
    foreach ($folder in $fullpathname)
        {
            
            
            $o = get-acl -Path $folder.FullName
            #foreach($right in ($o.access.IdentityReference ))
            foreach($right in ($o.access ))
            {
                
             if ($right.IdentityReference -like "*Verwaltung*")
                {
                $object = New-Object psobject
                $object | Add-Member NoteProperty Path ($folder.FullName)
                #$grp = $right.Value.Split("\")[1]
                $grp = $right.IdentityReference.Value.Split("\")[1]
                $object | Add-Member NoteProperty Right $grp
                $object | Add-Member NoteProperty FileSystemRight $right.FileSystemRights
                $object | Add-Member NoteProperty Grouptype (Get-ADGroup -filter "name -eq '$grp'"  -searchbase "OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local" | select GroupScope).GroupScope
                }

            }
            $allShares += $object
          # get-acl -Path $folder.FullName | % {$object | Add-Member NoteProperty Right $_.AccessToString }
          #  }
          $allShares  
        }
}
$allShares = @() # Arraylist for information
$server = "srv-file-001"
$path = "\\$server\Users\IFE"

$filer = $true
if ($filer){
    # Get all Folders
    [System.Collections.ArrayList]$fullpathname = Get-ChildItem -Path $path -Directory -Depth 2  # | select -ExpandProperty Name,FullName
    # exclude "Forschung allg." because dot at the end
    $fullpathname = $fullpathname | where {$_.name -ne "Forschung allg" -or $_.name -ne " Videos "}
    $permissiononFiler = Get-permissionOnFiler 
    $permissiononFiler  | Export-Csv C:\_MBA\data\sharepermissin-IFE.csv -Append -Encoding UTF8 -NoTypeInformation
}
$p = $permissiononFiler.Right | Get-Unique
$allGlobalgroupsfromFiler = @()
foreach($groupfromfiler in $p)
{
    $grouparray = (Get-ADGroupMember -Identity $groupfromfiler)
    foreach($g in $grouparray){
    $globalgroup = New-Object psobject
    $globalgroup | Add-Member NoteProperty GroupOnFiler $groupfromfiler
    $globalgroup | Add-Member NoteProperty MemberGroupName $g.name
    $globalgroup | Add-Member NoteProperty ObjektType $g.objectClass

    $allGlobalgroupsfromFiler += $globalgroup
    }
    
}
$allGlobalgroupsfromFiler | export-csv -NoTypeInformation -Encoding UTF8 -Path C:\_MBA\data\globalGroupsFromFileServer.csv
$a = $allGlobalgroupsfromFiler.MemberGroupName | Get-Unique

# Test ohne function
Get-ChildItem -Path "\\$server\Users\IFE" -Directory -Depth 2 | get-acl | %{$_.access | select FileSystemRights,IdentityReference}
