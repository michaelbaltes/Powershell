### Get the user credentials
$credential = Get-Credential
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

### Input Parameters
$url = 'https://sharepointonlinesiteurl'
$csvfilepath='path of csv data file containing list of folders and group permissions'
$libname ='name of the document library'


### References
# Specified the paths where the dll's are located.
Add-Type -Path 'c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll'
Add-Type -Path 'c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll'


### CreateFolder with Permissions Function
function CreateFolderWithPermissions()
{

    # Connect to SharePoint Online and get ClientContext object.
    $clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url)
    $credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $securePassword)
    $clientContext.Credentials = $credentials
	

    Function GetRole
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory = $true, Position = 1)]
            [Microsoft.SharePoint.Client.RoleType]$rType
        )

        $web = $clientContext.Web
        if ($web -ne $null)
        {
            $roleDefs = $web.RoleDefinitions
            $clientContext.Load($roleDefs)
            $clientContext.ExecuteQuery()
            $roleDef = $roleDefs | Where-Object { $_.RoleTypeKind -eq $rType }
            return $roleDef
        }
        return $null
    }

    # Get the SharePoint web
    $web = $clientContext.Web;
	$clientContext.Load($web)

	#Get the groups
$groups = $web.SiteGroups
$clientContext.Load($groups)
$clientContext.ExecuteQuery()
	

#Read CSV File and iterate
$csv = Import-CSV $csvfilepath
foreach ($row in $csv)
 {
#Create Folder
 $folder = $web.Folders.Add($libname + '\'+ $row.Folder)
 $clientContext.Load($folder1)
 $clientContext.ExecuteQuery()

 #Assign Role
$group = $groups.GetByName($row.Group)
$clientContext.Load($group)
$clientContext.ExecuteQuery()

 $roleType= $row.Role
 $roleTypeObject = [Microsoft.SharePoint.Client.RoleType]$roleType
    $roleObj = GetRole $roleTypeObject
	$usrRDBC = $null
    $usrRDBC = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($clientContext)
    $usrRDBC.Add($roleObj)

	 # Remove inherited permissions
	$folder.ListItemAllFields.BreakRoleInheritance($false, $true)
	$clientContext.Load($folder1.ListItemAllFields.RoleAssignments.Add($group, $usrRDBC))
	$folder.Update()
    $clientContext.ExecuteQuery()

    # Display the folder name and permission
    Write-Host -ForegroundColor Blue 'Folder Name: ' $folder.Name ' Group: '$row.Group ' Role: ' $roleType;
    
}
    
}
#Execute the function
CreateFolderWithPermissions
