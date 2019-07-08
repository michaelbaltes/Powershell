$VSPHtempfolder = "$env:USERPROFILE\AppData\Local\OMNINET GmbH\OMNITRACKER\Temp"
$VSPHtempfolder

foreach($datei in (get-childitem -Path $VSPHtempfolder))

{
    write-host "delete: " + $datei.name | out-file -FilePath c:\temp\del.log -Append
    remove-item -path $datei.FullName -Recurse -Force 
}