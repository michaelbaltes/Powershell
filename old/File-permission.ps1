function Get-permissionOnFiler ($folderpath) {
<#
  .SYNOPSIS
  Get all ACL based on variable $folderpath
  .DESCRIPTION
  Read all Acl in deth of get-childitem and give back as object like

  Path                                Right           FileSystemRight   Grouptype
  ----                                -----           ---------------   ---------
  
  .EXAMPLE
  Get-permissionOnFiler -folderpath (get-childitem -path c:\Test -directory -deth 2)
  .PARAMETER computername
  The computer name to query. Just one.
  .PARAMETER logname
  The name of a file to write failed computer names to. Defaults to errors.txt.
  #>

$allShares = @() # Arraylist for information

 foreach ($folder in $fullpathname)
  {
   $o = get-acl -Path $folder.FullName
    foreach($right in ($o.access ))
     {
      if ($right.IdentityReference -like "*Verwaltung*")
       {
        $object = New-Object psobject
        $object | Add-Member NoteProperty Path ($folder.FullName)
        $grp = $right.IdentityReference.Value.Split("\")[1]
        $object | Add-Member NoteProperty Right $grp
        $object | Add-Member NoteProperty FileSystemRight $right.FileSystemRights
        $object | Add-Member NoteProperty Grouptype (Get-ADGroup -filter "name -eq '$grp'"  -searchbase "OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local" | select GroupScope).GroupScope
        
        # read members of local groups and member of global groups
        $user = (Get-ADGroupMember -Identity $grp | % {Get-ADGroupMember -Identity $_}) 
        $users = @()
        $userdisplayname = @()
        # if more groups inside..... query it
            foreach($u in $user)
             {
              if($u.objectClass -eq 'user')
               {
                $users += $u.SamAccountName
                #$userdisplayname +=  (get-aduser $u -Properties displayname).displayname
               }
              else
               {
                $users += (Get-ADGroupMember -Identity $u.SamAccountName).samaccountName
                #$userdisplayname +=  (Get-ADGroupMember $u -Properties displayname).displayname 
               }    
             }
        
        # add users to object
        $object | Add-Member NoteProperty Members $users
        $object | Add-Member NoteProperty MemberDisplayname $userdisplayname
       }

      }
     $allShares += $object
  }
 $allShares  
}




# ~~~~~~~~~~~~~ Main ~~~~~~~~~~~~~~~~~~~~~~
#
$server = "srv-file-001"
$path = "\\$server\d$\Users\ZV"

# Get all Folders in deth
[System.Collections.ArrayList]$fullpathname = Get-ChildItem -Path $path -Directory -Depth 1

# Get all permission for each folder and save it 
$permissiononFiler = Get-permissionOnFiler -folderpath $fullpathname

# Export data
$permissiononFiler | select Path,Right,FileSystemRight,MemberDisplayname, @{Name='Members';Expression={[string]::Join(",",($_.members))}} | export-csv -Path C:\_MBA\data\ZV-NEU.csv -Encoding UTF8 -NoTypeInformation

# destroy object
$permissiononFiler = $null


#
# ~~~~~~~~~~~~~ Main ~~~~~~~~~~~~~~~~~~~~~~


