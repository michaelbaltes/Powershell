# https://www.administrator.de/wissen/powershell-funktion-credentials-anmeldeinformationsverwaltung-tresor-hinzufügen-nativ-cmdkey-exe-239337.html
function Add-WindowsCredentials {
param(
    [parameter(mandatory=$true)][ValidateSet("Windows","Generic")][string]$Type,
    [parameter(mandatory=$true)][ValidateSet("Session","LocalMachine","Enterprise")][string]$Persistence,
    [parameter(mandatory=$true)][ValidateNotNullOrEmpty()][string]$Server,
    [parameter(mandatory=$true)][ValidateNotNullOrEmpty()][string]$Username,
    [parameter(mandatory=$true)][ValidateNotNullOrEmpty()][string]$Password
)

$memberdef = @"
[DllImport("Advapi32.dll", SetLastError=true, EntryPoint="CredWriteW", CharSet=CharSet.Unicode)]
public static extern bool CredWrite([In] ref Credential userCredential, [In] UInt32 flags);

[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
public struct Credential
{
   public UInt32 flags;
   public UInt32 type;
   public IntPtr targetName;
   public IntPtr comment;
   public System.Runtime.InteropServices.ComTypes.FILETIME lastWritten;
   public UInt32 credentialBlobSize;
   public IntPtr credentialBlob;
   public UInt32 persist;
   public UInt32 attributeCount;
   public IntPtr Attributes;
   public IntPtr targetAlias;
   public IntPtr userName;
}
"@
    Add-Type -MemberDefinition $memberdef -Namespace "ADVAPI32" -Name 'Credentials'
    $cred = New-Object ADVAPI32.Credentials+Credential
    $cred.attributeCount = 0
    $cred.flags = 0
    $cred.targetName = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($Server)
    $cred.userName = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($Username)
    $cred.credentialBlobSize = [System.Text.Encoding]::Unicode.GetBytes($Password).length
    $cred.credentialBlob = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($Password)
    # Domain-Credentials oder Generic-Credentials erzeugen
    switch($Type){
        "Domain" {$cred.type = 2}
        "Generic" {$cred.type = 1}
    }
    #Erhalten der Credentials: 1 = Session / 2 = Local Machine / 3 = Enterprise
    switch($Persistence){
        "Session" {$cred.persist = 1}
        "LocalMachine" {$cred.persist = 2}
        "Enterprise" {$cred.persist = 3}
    }
    $result = [ADVAPI32.Credentials]::CredWrite([ref]$cred,0)
    return $result
}
