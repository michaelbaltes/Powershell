Connect-AzureAD

$allUserfromfile = Get-Content -Path C:\_MBA\data\LVGA.txt

foreach ($user in $allUserfromfile)
{
$user = $user.trim()
Write-Host $user
$objectuserID = Get-AzureADUser -ObjectId $user | select ObjectId

# 8678e7ac-b249-44a9-a12d-a6de58454679 is ID of group I fetch before
Add-AzureADGroupMember -ObjectId "8678e7ac-b249-44a9-a12d-a6de58454679" -RefObjectId $objectuserID.ObjectId
}



Disconnect-AzureAD