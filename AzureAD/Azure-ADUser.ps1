Connect-AzureAD
$user = "michael.baltes@phbern.ch"
$objectuserID = Get-AzureADUser -ObjectId $user | select ObjectId




Disconnect-AzureAD