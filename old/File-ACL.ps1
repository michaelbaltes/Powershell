#Set variables
$path = Read-Host "Enter the path you wish to check"
$filename = Read-Host "Enter Output File Name"
$date = Get-Date
#Place Headers on out-put file
$list = "Permissions for directories in: $Path"
$list | format-table | Out-File "C:\Users\admrmba\Downloads\$filename"
$datelist = "Report Run Time: $date"
$datelist | format-table | Out-File -append "C:\Users\admrmba\Downloads\$filename"
$spacelist = " "
$spacelist | format-table | Out-File -append "C:\Users\admrmba\Downloads\$filename"
#Populate Folders Array
[Array] $folders = Get-ChildItem -path $path -force -recurse | Where {$_.PSIsContainer}
#Process data in array
ForEach ($folder in [Array] $folders)
{
#Convert Powershell Provider Folder Path to standard folder path
$PSPath = (Convert-Path $folder.pspath)
$list = ("Path: $PSPath")
$list | format-table | Out-File -append "C:\Users\admrmba\Downloads\$filename"
Get-Acl -path $PSPath | Format-List -property AccessToString | Out-File -append "C:\Users\admrmba\Downloads\$filename"
} #end ForEach