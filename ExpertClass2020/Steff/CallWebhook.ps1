$TeamsWebHook = ''

$Body         = @{
  Attribute01 = ''               # VMName
  Attribute02 = 'Status'                        # VMAction Start/Stop/Status
  Attribute03 = $TeamsWebHook
}

$Body = (ConvertTo-Json $Body) 

$WebHook = 'https://s2events.azure-automation.net/webhooks?token='

# Invokes using the Hybrid Runbook Worker 
Invoke-RestMethod -Uri $WebHook `
                  -Body $Body `
                  -Method Post
