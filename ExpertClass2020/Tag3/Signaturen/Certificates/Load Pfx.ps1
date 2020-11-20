


function Load-PfxCertificate
{
  #Content
  param
  (
    [String]
    [Parameter(Mandatory)]
    $FilePath,
    
    [SecureString]
    [Parameter(Mandatory)]
    $Password
  )
  
  # get clear text password
  $plaintextPassword = [PSCredential]::new("X", $Password).GetNetworkCredential().Password
  
  
   [void][System.Reflection.Assembly]::LoadWithPartialName("System.Security")
    $container = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
    $container.Import($FilePath, $plaintextPassword, 'PersistKeySet')
    $container[0]
}
