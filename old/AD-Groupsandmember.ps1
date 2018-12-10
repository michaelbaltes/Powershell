
#########################################
<#
Get-ADGroup -filter "Groupcategory -eq 'Security' -AND GroupScope -eq 'DomainLocal' -AND Member -like '*'" |
foreach { 
 Write-Host "Exporting $($_.name)" -ForegroundColor Cyan
 $name = $_.name -replace " ","-"
 $file = Join-Path -path "C:\_MBA\data" -ChildPath "local_$name.csv"
 Get-ADGroupMember -Identity $_.distinguishedname -Recursive |  
 Get-ADObject -Properties SamAccountname,Title,Department |
 Select Name,SamAccountName,Title,Department,DistinguishedName,ObjectClass |
 Export-Csv -Path $file -NoTypeInformation
}
#>
#Universal
$server = "srv-file-001"
$path = "\\$server\Users"
# Get all attributes of user
# get-aduser –filter * -property * | select-object Name, LastLogonDate | export-CSV adusers.csv -NoTypeInformation -Encoding UTF8
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


# Get Permission on Filer function
function Get-permissionOnFiler () {
    foreach ($gruppe in (get-groups -category "'Security'" -scope "'Global'" -nameonly $false -namefilter '*' -searchBase "OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local")){
    $g = "VERWALTUNG\" + $gruppe
    #-Exclude "\\srv-file-001\Users\IHP\Forschung\Forschung allg."
    foreach ($folder in $fullpathname)
        {
        $temp = get-acl -Path $folder.FullName | select Path -ExpandProperty Access | where {$_.IdentityReference -eq $g} 
        if ($temp -ne $null){
        $temp | Export-Csv -Path C:\_MBA\data\Filepermission-global.csv -Append -NoTypeInformation
            }
        }
    }
}

function get-all-member ($group) {
    
    foreach($groupname in $group){
        if($groupname -ne $null){
            #Get-ADGroupMember -Identity $groupname.distinguishedname -Recursive
            #| Get-ADObject -Properties SamAccountname,Title,Department 
            #| Select Name,SamAccountName,Title,Department,DistinguishedName,ObjectClass    
            write-host $groupname -BackgroundColor Cyan
            Get-ADGroupMember -Identity $groupname.distinguishedname 

        }
        # | Export-Csv -Path $file -NoTypeInformation
    }
}

function ExcelRead () {
    # Object erstellen
    $objExcel = New-Object -ComObject Excel.Application
    $objExcel.Visible = $false
    # Datei anschnallen
    $WorkBook = $objExcel.Workbooks.Open("\\srv-file-001\Users\ZV\09 Projekte & Fachthemen\9.1 Projekte aktuell\9.12 Projekte ZV aktuell\future IT -fIT\03-KonzepteZurUmsetzung\1B-AD-Konzept&Namenskonvention\FilePermissionListe.xlsx")

    # welche mappen gibt es?
    $sheet =  ($WorkBook.sheets | Select-Object -Property Name).Name
    $sheetname = "used_local_groups_onFiler"
    # Mappe öffnen
    $WorkSheet = $WorkBook.Worksheets.Item($sheetname)

    # Starte mit Zeile n
    [int]$spalte = 1 # Spalte B
    [int]$zeile = 2 # Zeile 1 enhält die Überschrift
    $group = New-Object System.Collections.ArrayList
        do{
            $WorkSheet.Cells.Item($zeile,$spalte).text
            $zeile++ | Out-Null
            $group.Add($WorkSheet.Cells.Item($zeile,$spalte).text)
        }
        while($WorkSheet.Cells.Item($zeile,$spalte).text.length -gt 0)
        # Write-Warning $zeile
        #COM-Objektes beenden
    $objExcel.Quit()
    #COM-Objektes aus dem Speicher entfernen
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)  

    return $group
}

# Main
<# $filer = $false
$usedfilergroups = ExcelRead
$filer_Localgroups = $usedfilergroups | foreach { Get-ADGroup -Filter "Name -eq '$_'"}
get-all-member -group $filer_Localgroups | Export-Csv -Path C:\_MBA\data\filer_localgroupsMember.csv -Append

$all_Localgroups = get-groups -category "'Security'" -scope "'DomainLocal'" -nameonly $
false -namefilter '*' # '*IVP_L_QM*' # '*'

#$all_Globalgroups = get-groups -category "'Security'" -scope "'Global'" -nameonly $false -namefilter '*'

#$all_Globalgroups | select Name | Out-File C:\_MBA\data\all_globalgroups.txt

$all_localgroups | select Name | Out-File C:\_MBA\data\all_localgroups.txt


$users = get-aduser -Filter * 
foreach($user in $users){

   $groups= Get-ADPrincipalGroupMembership $user #| export-csv C:\_MBA\data\AllUserinGroups.csv #select -Property Name # -Recursive | Get-ADObject -Properties SamAccountname,Title,Department 
   foreach($group in $groups){
    $Props = @{
        UserID  = $User.SAMAccountName
        #UserDN  = $User.DistinguishedName
        GroupID = $group.SamAccountName
        GroupDN = $group.DistinguishedName
        IsUserPrimaryGroup = ( $group.DistinguishedName -eq $User.PrimaryGroup )
        }
        # One CSV line for each user/group 
        New-Object PSObject -Property $Props  | export-csv C:\_MBA\data\AllUserinGroups.csv -Append
    } 
}  
Get-ADUser -Server SRV-DC-008.phbecampus.phbern.local


$all_Localgroups = get-groups -category "'Security'" -scope "'DomainLocal'" -nameonly $false -namefilter '*' # '*IVP_L_QM*' # '*'
foreach($gruppe  in $all_Localgroups){Get-ADGroupMember $gruppe}
$a = Get-ADGroup -Filter "GroupScope -eq 'DomainLocal'" -Properties *

foreach ($group in $a)
{

$DomainLocalGroupName = $group.Name

$group | get-ADGroupMember | Select @{Name="DomainLocalGroupName"; Expression={$DomainLocalGroupName}}, Name

}  


$all_Globalgroups = get-groups -category "'Security'" -scope "'Global'" -nameonly $false -namefilter '*' -searchBase "OU=Verwaltung,DC=verwaltung,DC=phbern,DC=local"
get-all-member -group $all_Globalgroups
#>

$filer = $true
if ($filer){
    # Get all Folders
    [System.Collections.ArrayList]$fullpathname = Get-ChildItem -Path $path -Directory -Depth 2  # | select -ExpandProperty Name,FullName
    # exclude "Forschung allg." because dot at the end
    $fullpathname = $fullpathname | where {$_.name -ne "Forschung allg."}
    Get-permissionOnFiler 
}

