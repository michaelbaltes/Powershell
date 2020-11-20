# https://p0w3rsh3ll.wordpress.com/2017/09/19/psgallery-and-catalog-files/
# https://docs.microsoft.com/de-de/powershell/gallery/concepts/publishing-guidelines

$cert = New-CodeSigningCert -FriendlyName Tobias -Name Tobias -Trusted
$path = "C:\Users\Tobias\Documents\WindowsPowerShell\Modules"
$module = "Urlaubstools"
$catName = "$module.cat"
$modulepath = Join-Path -Path $path -ChildPath $module
$catPath = Join-Path -Path $modulepath -ChildPath $catName

# sign relevant module files
Get-ChildItem -Path $modulePath -Include *.psm1, *.psd1, *.ps1 -Recurse |
  Set-AuthenticodeSignature -Certificate $cert -TimestampServer http://timestamp.digicert.com -Verbose -HashAlgorithm SHA256

# remove old cat file
$exists = Test-Path -Path $catPath
if ($exists) { Remove-Item -Path $catPath -force }

New-FileCatalog -Path $modulepath -CatalogFilePath $catPath -CatalogVersion 2.0 -Verbose
Set-AuthenticodeSignature -FilePath $catPath -Certificate $cert -TimestampServer http://timestamp.digicert.com -Verbose -HashAlgorithm SHA256

Get-ChildItem -Path $modulepath -Recurse | Get-AuthenticodeSignature
Test-FileCatalog -Path $modulepath -CatalogFilePath $catPath -Detailed





