# IsMember.ps1
# PowerShell program to check security group membership in Active Directory.
# Author: Richard Mueller
# PowerShell Version 1.0
# July 5, 2011

# Hash table of security principals and their security group memberships.
$GroupList = @{}

Function IsMember ($ADObject, $GroupName)
{
    # Function to check if $ADObject is a member of security group $GroupName.

    # Check if security group memberships for this principal have been determined.
    If ($GroupList.ContainsKey($ADObject.sAMAccountName.ToString() + "\") -eq $False)
    {
        # Memberships need to be determined for this principal. Add "pre-Windows 2000"
        # name to the hash table.
        $GroupList.Add($ADObject.sAMAccountName.ToString() + "\", $True)
        # Retrieve tokenGroups attribute of principal, which is operational.
        $ADObject.psbase.RefreshCache("tokenGroups")
        $SIDs = $ADObject.psbase.Properties.Item("tokenGroups")
        # Populate hash table with security group memberships.
        ForEach ($Value In $SIDs)
        {
            $SID = New-Object System.Security.Principal.SecurityIdentifier $Value, 0
            # Translate into "pre-Windows 2000" name.
            $Group = $SID.Translate([System.Security.Principal.NTAccount])
            $GroupList.Add($ADObject.sAMAccountName.ToString() `
                + "\" + $Group.Value.Split("\")[1], $True)
        }
    }
    # Check if $ADObject is a member of $GroupName.
    If ($GroupList.ContainsKey($ADObject.sAMAccountName.ToString() + "\" + $GroupName))
    {
        Return $True
    }
    Else
    {
        Return $False
    }
}

# Bind to the user object in Active Directory.
$User = [ADSI]"LDAP://cn=TestUser,ou=Sales,dc=MyDomain,dc=com"

# Bind to the computer object in Active Directory.
$Computer = [ADSI]"LDAP://cn=TestComputer,ou=Sales,dc=MyDomain,dc=com"

If (IsMember $User "Engineering" -eq $True)
{
    "User " + $User.sAMAccountName + " is a member of group Engineering"
}

If (IsMember $User "Domain Users" -eq $True)
{
    "User " + $User.sAMAccountName + " is a member of group Domain Users"
}

If (IsMember $Computer "Deploy" -eq $True)
{
    "Computer " + $Computer.sAMAccountName + " is a member of group Deploy"
}