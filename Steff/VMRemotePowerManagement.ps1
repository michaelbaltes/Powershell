 [OutputType([object])] 	

 param
 (
   [object]$WebhookData
 )
 $VerbosePreference = 'Continue'
 $Result = Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"
 #############################################################################################################################################################
 #  
 # Import modules prior to Verbose setting to avoid clutter in Azure Automation log
 #
 #############################################################################################################################################################

 $VerbosePreference = 'SilentlyContinue'
 $Result = Import-Module Az.Automation, Az.Resources, Az.Compute
 $VerbosePreference = 'Continue'

 #############################################################################################################################################################
 #
 # Assign/map data received by REST call from PowerShell Script, to PowerShell variables
 #
 #############################################################################################################################################################
 $WebhookName = $WebhookData.WebhookName
 $RequestHeader = $WebhookData.RequestHeader
 $RequestBody = $WebhookData.RequestBody
 Write-Verbose -Message ('-WebhookName: ' + $WebhookName)
 Write-Verbose -Message ('-RequestHeader: ' + $RequestHeader)
 Write-Verbose -Message ('-RequestBody: ' + $RequestBody)
 Write-Verbose -Message ('-WebhookData: ' + $WebhookData)

 $Attributes = ConvertFrom-Json -InputObject $RequestBody
 Write-Verbose -Message ('-Attributes: ' + $Attributes)

 $VMName = $Attributes.Attribute01
 $VMAction = $Attributes.Attribute02
 $TeamsWebHook = $Attributes.Attribute03

 Write-Verbose -Message ('-VMName: ' + $VMName)
 Write-Verbose -Message ('-VMAction: ' + $VMAction)
 Write-Verbose -Message ('-TeamsWebHook: ' + $TeamsWebHook)

 #############################################################################################################################################################
 #  
 # Import Automation Account variables
 #
 #############################################################################################################################################################
 $connection = Get-AutomationConnection -Name AzureRunAsConnection
 $subscriptionId = Get-AutomationVariable -Name 'VARI-AUTO-VmMgmtSubscription'
 $ResourceGroupName = Get-AutomationVariable -Name 'VARI-AUTO-VmMgmtResourceGroup'

 #############################################################################################################################################################
 #  
 # Import context
 #
 #############################################################################################################################################################

 Disable-AzContextAutosave -Scope Process | Out-Null

 # Wrap authentication in retry logic for transient network failures
 $logonAttempt = 0
 while(!($connectionResult) -and ($logonAttempt -le 10))
 {
   $LogonAttempt++
   # Logging in to Azure...
   $connectionResult = Connect-AzAccount `
   -ServicePrincipal `
   -Tenant $connection.TenantID `
   -ApplicationId $connection.ApplicationID `
   -CertificateThumbprint $connection.CertificateThumbprint `
   -SubscriptionId $subscriptionId

   Start-Sleep -Seconds 30
 }

 $AzureContext = Get-AzSubscription -SubscriptionId $connectionResult.SubscriptionID

 Write-Verbose -Message ('-AzureContext: ' + ($AzureContext | Out-String))

 #############################################################################################################################################################
 #  
 # Stop or start VM
 #
 #############################################################################################################################################################

 $vmParam = @{
   Name = $VMName
   ResourceGroupName = $ResourceGroupName
 }

 $VMs = Get-AzVM @vmParam
 Write-Verbose -Message ('-VM: ' + ($VMs | Out-String))
 
 Switch ($VMAction){
   "Start" {$Result = Start-AzVM @vmParam}
   "Stop"  {$Result = Stop-AzVM -Force  @vmParam }
   "State" {}
 }
 
 Write-Verbose -Message ('-Result: ' + ($Result.Status | Out-String))

 #############################################################################################################################################################
 #  
 # Get VM state
 #
 #############################################################################################################################################################

 $VMDetail = Get-AzVM -Status @vmParam
 $VMStatus = ($VMDetail.Statuses | Where-Object {$_.Code -match 'PowerState/'}).DisplayStatus
 
 Write-Verbose -Message ('-VMStatus: ' + $VMStatus)

 #############################################################################################################################################################
 #  
 # Send message to Teams
 #
 #############################################################################################################################################################

 $JSONBody = [PSCustomObject][Ordered]@{
   "@type"      = "MessageCard"
   "@context"   = "http://schema.org/extensions"
   "summary"    = "VM Power Management"
   "themeColor" = '0078D7'
   "sections"   = @(
     @{
       "activityTitle"    = "VM Power Management"
       "activitySubtitle" = "Return of Runbook"
       "activityImage"    = "https://www.smartit.ch/uploads/icons(external_use)/favicon-smartit.png"
       "facts"            = @(
         @{
           "name"  = "VMName"
           "value" = $VMName
         },
         @{
           "name"  = "VMAction"
           "value" = $VMAction
         },
         @{
           "name"  = "VMStatus"
           "value" = $VMStatus
         }
       )
       "markdown" = $true
     }
   )
 }
 
 $TeamsMessageBody = ConvertTo-Json $JSONBody -Depth 100
 
 $parameters = @{
    "URI"         = $TeamsWebHook
    "Method"      = 'POST'
    "Body"        = $TeamsMessageBody
    "ContentType" = 'application/json'
 }
 
 Invoke-RestMethod @parameters | Out-Null
