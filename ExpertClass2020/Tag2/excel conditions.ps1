$time = Get-Date -Format 'yyyy-MM-dd_HH_mm_ss_ffff'
$Path = "$env:temp\report$time.xlsx"

# define two conditions

# condition 1:
# when text = "Stop", use darkred on lightpink
# condition 2:
# when text = "Running", use Green on LightGreen
$condition1 =  New-ConditionalText -ConditionalType GreaterThan -Text 10 -ConditionalTextColor DarkRed -BackgroundColor LightPink -Range B2:B1000

# get all services
Get-Process | 
    # choose some columns...
    Select-Object -Property Name, CPU |
    # format service status according to conditions
    Export-Excel -Path $Path -Show -ConditionalText $condition1