

$cred = Get-Credential tobias
$cred.GetType().FullName

$username = 'tobias'
$password = 'geheim' | ConvertTo-SecureString -AsPlainText -Force
$cred = [System.Management.Automation.PSCredential]::new($username, $password)
$cred

$Path = "$env:temp\test.xml"
Get-Credential tobias | Export-Clixml -Path $Path






notepad $Path

$cred = Import-Clixml -Path $Path


@{
    User1 = Get-Credential
    User2 = Get-Credential
} | Export-Clixml -Path $Path


$store = Import-Clixml -Path $Path
$store.User