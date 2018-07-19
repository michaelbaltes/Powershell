# Informationen zum Script siehe Link
# https://support.office.com/de-de/article/verwalten-von-personen-die-office-365-gruppen-erstellen-k%c3%b6nnen-4c46c8cb-17d0-44b5-9776-005fced8e618?ui=de-DE&rs=de-DE&ad=DE#why

Connect-AzureAD

New-AzureADGroup -DisplayName "Name der Gruppe" -SecurityEnabled $true -Description "Perosnen in dieser Gruppe können Teams erstellen"

# Kontrolle
Get-AzureADGroup -SearchString "<Name of your security group>"

# Standard Temaplate holen
$Template = Get-AzureADDirectorySettingTemplate | Where-Object {$_.DisplayName -eq 'Group.Unified'}

$Setting = $Template.CreateDirectorySetting()

# The New-AzureADDirectorySetting cmdlet creates a directory settings object in Azure Active Directory (AD).
# https://docs.microsoft.com/en-us/powershell/module/azuread/new-azureaddirectorysetting?view=azureadps-2.0-preview
New-AzureADDirectorySetting -DirectorySetting $Setting

Get-AzureADDirectorySetting
$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | Where-Object -Property DisplayName -Value "Group.Unified" -EQ).id

# Kontrolle
$Setting

$Setting["EnableGroupCreation"] = $False
$Setting["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString "a_O365_Right").objectid
Set-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | Where-Object -Property DisplayName -Value "Group.Unified" -EQ).id -DirectorySetting $Setting

# Kontrolle
(Get-AzureADDirectorySetting).Values