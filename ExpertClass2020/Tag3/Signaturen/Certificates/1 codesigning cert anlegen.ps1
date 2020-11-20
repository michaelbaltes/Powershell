function New-CodeSigningCert
{
    param
    (
        [Parameter(Mandatory, Position=0)]
        [System.String]
        $FriendlyName,
        
        [Parameter(Mandatory, Position=1)]
        [System.String]
        $Name,
        
        [Parameter(Mandatory, Position=2)]
        [string]
        $Path,
        
        [Parameter(Mandatory, Position=3)]
        [SecureString]
        $Password
    )
    
    # Zertifikat anlegen:
    $cert = New-SelfSignedCertificate -KeyUsage DigitalSignature -KeySpec Signature -FriendlyName $FriendlyName -Subject "CN=$Name" -KeyExportPolicy ExportableEncrypted -CertStoreLocation Cert:\CurrentUser\My -NotAfter (Get-Date).AddYears(5) -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.3')
    
    
    # Zertifikat in Datei exportieren:
    $cert | Export-PfxCertificate -Password $Password -FilePath $Path
    # Zertifikat aus Speicher löschen:
    $cert | Remove-Item
}

