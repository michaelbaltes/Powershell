$DomainName = 'intra.phbern.ch'
$AdIntegrationType = 'Domain'
$DomainDn = (Get-AdDomain).DistinguishedName
Get-ChildItem "AD:DC=$DomainName,CN=MicrosoftDNS,DC=$AdIntegrationType`DnsZones,$DomainDn" | foreach {Get-Acl -Path "ActiveDirectory:://RootDSE/$($_.DistinguishedName)"}
