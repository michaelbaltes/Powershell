$includeGlobal = @()
$includeLocal = @()
$includeUniversal = @()
foreach ($g in (Get-ADGroup -Filter * -Properties * -server srv-dc-007 | where {$_.extensionattribute1 -ne $null}))
{
# create Arraylist object

    switch ($g.GroupScope)
        {
        "Universal" {
                        $object = New-Object psobject
                        $object | Add-Member NoteProperty SourceName ($g.SamAccountName)
                        $object | Add-Member NoteProperty TargetRDN ("CN=" + $g.extensionAttribute1.TrimEnd())
                        $object | Add-Member NoteProperty TargetSAM ($g.extensionAttribute1.TrimEnd())
                        #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_Universal.txt -Append -Encoding utf8 -NoTypeInformation
                        $includeUniversal += $object
                      }
        "Global" {
                        $object = New-Object psobject
                        $object | Add-Member NoteProperty SourceName ($g.SamAccountName)
                        $object | Add-Member NoteProperty TargetRDN ("CN=" + $g.extensionAttribute1.TrimEnd())
                        $object | Add-Member NoteProperty TargetSAM ($g.extensionAttribute1.TrimEnd())
                        #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_Global.txt -Append -Encoding utf8 -NoTypeInformation
                        $includeGlobal += $object
                      }
        "DomainLocal" {
                        $object = New-Object psobject
                        $object | Add-Member NoteProperty SourceName ($g.SamAccountName)
                        $object | Add-Member NoteProperty TargetRDN ("CN=" + $g.extensionAttribute1.TrimEnd())
                        $object | Add-Member NoteProperty TargetSAM ($g.extensionAttribute1.TrimEnd())
                        #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_local.txt -Append -Encoding utf8 -NoTypeInformation
                        $includeLocal += $object
                      }
                      
        }
        $includeGlobal | export-csv -Path C:\_MBA\data\Migration_GlobalGroups_final-campus.csv -NoTypeInformation -Encoding UTF8
        $includeLocal | export-csv -Path C:\_MBA\data\Migration_LocalGroups_final-campus.csv -NoTypeInformation -Encoding UTF8
        $includeUniversal | export-csv -Path C:\_MBA\data\Migration_UniversalGroups_final-campus.csv -NoTypeInformation -Encoding UTF8
}