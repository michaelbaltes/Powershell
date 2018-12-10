$AllUserStudent = @()
$AllUserStaff = @()
$AllUserFromFile = @()

# ***** Start Variablen *******
$staff = $true
$CampusServer = "srv-dc-007"
$VerwaltungServer = "srv-dc-004"
$usefile = $false
$ID = "320"
# ***** End Variablen *******

<#
ID	Name	Kürzel
100	Rektorat	Rektorat
110	Zentrale Verwaltung	ZV
120	Institut Vorschulstufe und Primarstufe	IVP
130	Institut Sekundarstufe I	Sek. I
140	Institut Sekundarstufe II	Sek. II
150	Institut für Heilpädagogik	IHP
180	Institut für Weiterbildung und Medienbildung	IWM
230	Institut für Forschung, Entwicklung und Evaluation	IFE
310	Verwaltung Grundausbildungen	VGA
320	Verwaltung Weiterbildung und Forschung	VWF
400	Privates Institut Vorschulstufe und Primarstufe (NMS)	NMS
#>


if ($staff -and $usefile -eq $false)
{
    Write-Warning -Message "Create CSV for staff without file!" 

    # AD Verwaltung
    foreach ($uVerwaltung in (Get-ADuser -Filter * -Properties * -server $VerwaltungServer | where {$_.employeeType -eq "staff" -and $_.departmentNumber -eq $ID -and $_.Enabled -eq $true}))
        {
        $object = New-Object psobject
        $object | Add-Member NoteProperty SourceName ($uVerwaltung.SamAccountName)
        #$object | Add-Member NoteProperty TargetRDN ("""" + "CN=" + $($uVerwaltung.UserPrincipalName.Split("@")[0] + """"))
        $object | Add-Member NoteProperty TargetRDN ("CN=" + $($uVerwaltung.UserPrincipalName.Split("@")[0]))
        $object | Add-Member NoteProperty TargetUPN ($uVerwaltung.userPrincipalName)
        #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_Universal.txt -Append -Encoding utf8 -NoTypeInformation
        $AllUserStaff += $object
        }
        
    foreach ($uCampus in (Get-ADuser -Filter * -Properties * -server $CampusServer | where {$_.employeeType -eq "staff" -and $_.departmentNumber -eq $ID -and $_.Enabled -eq $true}))
        {
        $object = New-Object psobject
        $object | Add-Member NoteProperty SourceName ($uCampus.SamAccountName)
        #$object | Add-Member NoteProperty TargetRDN ("""" + "CN=" + $($uCampus.UserPrincipalName.Split("@")[0] + """"))
        $object | Add-Member NoteProperty TargetRDN ("CN=" + $($uCampus.UserPrincipalName.Split("@")[0]))
        $object | Add-Member NoteProperty TargetUPN ($uCampus.userPrincipalName)
        #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_Universal.txt -Append -Encoding utf8 -NoTypeInformation
        $AllUserStaff += $object
        }
                     
    $AllUserStaff| export-csv -Path C:\_MBA\data\ADMT\Migration-User-$ID.csv -NoTypeInformation -Encoding UTF8
}
elseif($usefile -eq $false)
{
    Write-Warning -Message "Create CSV for students without file!" 
    
    # AD Campus
    foreach ($uCampus in (Get-ADuser -Filter * -Properties * -server $CampusServer | where {$_.extensionAttribute2 -eq "student"}))
        {
        $object = New-Object psobject
        $object | Add-Member NoteProperty SourceName ($uCampus.SamAccountName)
        #$object | Add-Member NoteProperty TargetRDN ("""" + "CN=" + $($uCampus.UserPrincipalName.Split("@")[0] + """"))
        $object | Add-Member NoteProperty TargetRDN ("CN=" + $($uCampus.UserPrincipalName.Split("@")[0]))
        $object | Add-Member NoteProperty TargetUPN ($uCampus.userPrincipalName)
        #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_Universal.txt -Append -Encoding utf8 -NoTypeInformation
        $AllUserStudent += $object
        }
                      
    $AllUserStudent| export-csv -Path C:\_MBA\data\Migration_Users_final-student_2018-03-19_v2.csv -NoTypeInformation -Encoding UTF8
}
else
{




$usersfromFile = get-content -Path "C:\_MBA\data\GP-Verwaltung.txt"
#$uVerwaltung = get-aduser -Filter * -Properties * -Server srv-dc-004
#$uCampusAll = get-aduser -Filter * -Properties * -Server srv-dc-007
   Write-Warning -Message "Create CSV from file!" 
    # AD Campus
    foreach ($user in $usersfromFile)
        {
        $uCampus = $null
        #Namen
         $uCampus = get-aduser -Filter {UserPrincipalName -eq $user} -Properties DisplayName 
         # | where{$_.mail -eq $user}
        #$uCampus = $uVerwaltung | where{$_.mail -eq $user}
       if($uCampus -ne $null)
            {
             Write-Warning -Message "Work on Verwaltung"
            $uCampus.name; $ucampus.mail;$uCampus.UserPrincipalName
            $object = New-Object psobject
            $object | Add-Member NoteProperty SourceName ($uCampus.SamAccountName)
            #$object | Add-Member NoteProperty TargetRDN ("""" + "CN=" + $($uCampus.UserPrincipalName.Split("@")[0] + """"))
            $object | Add-Member NoteProperty TargetRDN ("CN=" + $($uCampus.UserPrincipalName.Split("@")[0]))
            $object | Add-Member NoteProperty TargetUPN ($uCampus.userPrincipalName)
            #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_Universal.txt -Append -Encoding utf8 -NoTypeInformation
            $AllUserFromFile += $object
            }
            else
            {
            <#
            Write-Warning -Message "Work on Campus"
            $uCampus = $null
            $uCampus = get-aduser -Filter * -Properties * -Server srv-dc-007| where{$_.mail -eq $user}
            #$uCampus = get-aduser $user -Server srv-dc-007
            #$uCampus = $uCampusAll | where{$_.mail -eq $user}
            $uCampus.name; $ucampus.mail;$uCampus.UserPrincipalName
            $object = New-Object psobject
            $object | Add-Member NoteProperty SourceName ($uCampus.SamAccountName)
            #$object | Add-Member NoteProperty TargetRDN ("""" + "CN=" + $($uCampus.UserPrincipalName.Split("@")[0] + """"))
            $object | Add-Member NoteProperty TargetRDN ("CN=" + $($uCampus.UserPrincipalName.Split("@")[0]))
            $object | Add-Member NoteProperty TargetUPN ($uCampus.userPrincipalName)
            #$g | select SamAccountName,extensionAttribute1 | export-csv -Path c:\_mba\data\include_Universal.txt -Append -Encoding utf8 -NoTypeInformation
            $AllUserFromFile += $object
            #>
            }

        }
                      
    $AllUserFromFile| export-csv -Path C:\_MBA\data\ADMT\GP.csv -NoTypeInformation -Encoding UTF8


}        