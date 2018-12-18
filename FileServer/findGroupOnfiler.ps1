
# - Variablen -
param (
    $folder = $(read-host "Where should I search? e.g. \\srv-file-001.verwaltung.phbern.local\Users"), # "\\srv-file-001.verwaltung.phbern.local\Users",
    $searchpattern = $(read-host "What we are searching for? Referenced on local Group"),
    $depth = $(read-host "How deep should I search? e.g 0-3")
)
# - Variablen -

#region Funktionen
    function get-folderInfo {
        param 
        (
            $folderpath,
            $folderdepth
        )
        $primaerFolder = @()
        foreach ($f in (Get-ChildItem -Path $folderpath -Directory -Depth $folderdepth  ))
        {
            $acl = Get-Acl -Path $f.fullname
            foreach ($right in ($acl.access))
            {
                if ($right.IdentityReference -like "INTRA\*")
                {
                    $myFolderobject = [PSCustomObject]@{
                        PrimaerFoldername = $f.fullname
                        PrimaerFolderAcl = $right.FileSystemRights
                        PrimaerFolderACLGroup = $right.IdentityReference
                    }
                    $primaerFolder += $myFolderobject
                }
            }
        }
      $primaerFolder  
    
    }
#endregion

#region # ----------MAIN START ----------

$all = get-folderInfo -folderpath $folder -folderdepth $depth
foreach ($i in $all)
{
if ($i.PrimaerFolderACLGroup.value -match $searchpattern)
    {
        Write-Warning $i.PrimaerFoldername          
    }
}

#endregion # ----------MAIN END ----------

