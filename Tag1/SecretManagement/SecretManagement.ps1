# https://devblogs.microsoft.com/powershell/secrets-management-module-vault-extensions/
Install-Module Microsoft.PowerShell.SecretManagement -AllowPrerelease
Install-Module Microsoft.PowerShell.SecretStore -AllowPrerelease
Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

Get-SecretVault
Get-SecretInfo
Set-Secret -Name kunde1 -SecureStringSecret ("geheim" | ConvertTo-SecureString -AsPlainText -Force) -Vault SecretStore
Get-Secret -Name kunde1
Get-SecretInfo
Set-Secret -Name kunde2 -Secret (Get-Credential) -Vault SecretStore
Get-Secret -Name kunde2

Get-WMIObject -Class Win32_BIOS -Computer server1 -Credential (Get-Secret -Name kunde2)