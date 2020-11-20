
$PfxPath = "$home\Desktop\cert.pfx"
$Password = "secret" | ConvertTo-SecureString -AsPlainText -Force
<#
New-CodeSigningCert -FriendlyName Tobias2 -Name Tobias2 -Password $Password -FilePath $PfxPath -Trusted
#>

$cert = Load-PfxCertificate -FilePath $PfxPath -Password $Password

$path = "C:\Users\Tobias\Documents\WindowsPowerShell\Modules"
$module = "Urlaubstools"
$catName = "$module.cat"
$modulepath = Join-Path -Path $path -ChildPath $module
$catPath = Join-Path -Path $modulepath -ChildPath $catName

# sign relevant module files
Get-ChildItem -Path $modulePath -Include *.psm1, *.psd1, *.ps1 -Recurse |
  Set-AuthenticodeSignature -Certificate $cert -TimestampServer http://timestamp.digicert.com -Verbose -HashAlgorithm SHA256
Start-Sleep -Seconds 1

# remove old cat file
$exists = Test-Path -Path $catPath
if ($exists) { Remove-Item -Path $catPath -force }
New-FileCatalog -Path $modulepath -CatalogFilePath $catPath -CatalogVersion 2.0 -Verbose 
Set-AuthenticodeSignature -FilePath $catPath -Certificate $cert -TimestampServer http://timestamp.digicert.com -Verbose -HashAlgorithm SHA256

Get-ChildItem -Path $modulepath -Recurse | Get-AuthenticodeSignature
$info = Test-FileCatalog -Path $modulepath -CatalogFilePath $catPath -Detailed
$info
$info.CatalogItems




