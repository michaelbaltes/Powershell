Import-Module "E:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager\ConfigurationManager.psd1"
Set-Location BE0:
$computer = 'g25607'
# $colLIstFromCustomer = get-content C:\temp\apps.txt

function delete-membership($colLIstFromCustomer)
{
foreach($app in $colLIstFromCustomer)
{
    if($app -match '(Full Install)')
        {
        Remove-CMDeviceCollectionDirectMembershipRule -CollectionName $app -ResourceName $computer -Force
        }
 # Gets client member of given collection   
 #if ( (Get-CMDevice -CollectionName ($app -replace '(Full)', 'Full Install') | select -ExpandProperty Name) -eq $computer)
     #{
     # remove from collection
     # Remove-CMDeviceCollectionDirectMembershipRule -CollectionName ($app -replace '(Full)', 'Full Install') -ResourceName $computer -Force
     #}
}
}

function get-ComColMember()
{
$ResID = (Get-CMDevice -Name $computer).ResourceID
$Collections = (Get-WmiObject -Class sms_fullcollectionmembership -Namespace root\sms\site_BE0 -Filter "ResourceID = '$($ResID)'").CollectionID
    foreach ($Collection in $Collections)
    {
      Get-CMDeviceCollection -CollectionId $Collection | select Name, CollectionID
    }
}

$col = get-ComColMember | select -ExpandProperty Name
delete-membership -colLIstFromCustomer $col 