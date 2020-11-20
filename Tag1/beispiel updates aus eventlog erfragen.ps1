



Get-EventLog  -LogName System -InstanceId 19  |
    ForEach-Object {
        [PSCustomObject]@{
            Time = $_.TimeGenerated
            Update = $_.ReplacementStrings[0]
        }
    } 
    
Get-WinEvent -FilterHashtable @{LogName = "System";ID=19} |
    ForEach-Object {
        [PSCustomObject]@{
            Time = $_.TimeCreated
            Update = $_.Properties[0].Value
        }
    }
    
    
   $a = Get-WinEvent -FilterHashtable @{LogName = "OAlerts"} -MaxEvents 1
   $a.Properties
   
    $a = Get-WinEvent -FilterHashtable @{LogName = "Microsoft-Windows-PowerShell/Operational"} -MaxEvents 1
   $a.Properties
   
   

