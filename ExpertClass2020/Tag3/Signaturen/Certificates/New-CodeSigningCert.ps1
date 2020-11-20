function New-CodeSigningCert
{
  [CmdletBinding(DefaultParametersetName="__AllParameterSets")]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $FriendlyName,
    
    [Parameter(Mandatory)]
    [String]
    $Name,
    
    [Parameter(Mandatory,ParameterSetName="Export")]
    [SecureString]
    $Password,
    
    [Parameter(Mandatory,ParameterSetName="Export")]
    [String]
    $FilePath,
    
    [Switch]
    $Trusted
  )
  
  # Zertifikat anlegen:
  $cert = New-SelfSignedCertificate -KeyUsage DigitalSignature -KeySpec Signature -FriendlyName $FriendlyName -Subject "CN=$Name" -KeyExportPolicy ExportableEncrypted -CertStoreLocation Cert:\CurrentUser\My -NotAfter (Get-Date).AddYears(5) -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.3')
  
  
  if ($Trusted)
  {
    $Store = New-Object system.security.cryptography.X509Certificates.x509Store("Root", "CurrentUser")
    $Store.Open("ReadWrite")
    $Store.Add($cert)
    $Store.Close()
  }


  $parameterSet = $PSCmdlet.ParameterSetName.ToLower()
  
  if ($parameterSet -eq "export")
  {
    # Zertifikat in Datei exportieren:
    $cert | Export-PfxCertificate -Password $Password -FilePath $FilePath
  
    $cert | Remove-Item
    explorer.exe /select,$FilePath
  }
  else
  {
    $cert
  }
}

