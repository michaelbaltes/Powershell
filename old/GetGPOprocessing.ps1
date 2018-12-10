<#
----------------------------------------
File: getgpoprocessing.ps1
Version: 2.0
Authors: Thomas Bouchereau, Pierre Audonnet
-----------------------------------------

Disclaimer:
This sample script is not supported under any Microsoft standard support program or service. 
The sample script is provided AS IS without warranty of any kind. Microsoft further disclaims 
all implied warranties including, without limitation, any implied warranties of merchantability 
or of fitness for a particular purpose. The entire risk arising out of the use or performance of 
the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, 
or anyone else involved in the creation, production, or delivery of the scripts be liable for any 
damages whatsoever (including, without limitation, damages for loss of business profits, business 
interruption, loss of business information, or other pecuniary loss) arising out of the use of or 
inability to use the sample scripts or documentation, even if Microsoft has been advised of the 
possibility of such damages 
 #>

<# 

.EXAMPLE
GetGPOprocessing.ps1 -hours 5

This command will allow to review the events of the last 5 hours on local computer

.EXAMPLE
GetGPOprocessing.ps1 -computer 2012MS -hours 5

This command will allow to review the events of the last 5 hours on computer "2012MS"

.EXAMPLE
GetGPOprocessing.ps1 -hours 5 -csv $true

This command will allow to review the events of the last 5 hours on local computer and export the result into a CSV file

.EXAMPLE
GetGPOprocessing.ps1 -hours 5 -csv $true -html $true

This command will allow to review the events of the last 5 hours on local computer and export the result into a HTML and CSV files

#>


param(
    [string] $computer = "localhost",
    [int]    $hours    = 5,
    [bool]   $csv      = $false,
    [bool]   $html     = $false
)

#Get date relative to the number of hours you want to review
$date = (Get-Date).Addhours(-$($hours))


#load the name of the Winevent log corresponding to Group Policy
$loggpo= "Microsoft-Windows-GroupPolicy/Operational"
$ids = 4000..4007
$i = 0
$templist = @()

$gpoprocessevents = Get-WinEvent -FilterHashtable @{ LogName = $loggpo ; StartTime = $date } -ComputerName $computer -Oldest

#If exists, list all GPO processing present during the periode of time specify
if ($gpoprocessevents.count -ne 0 )
{
    Write-host "List of GPO processing events of the last $($hours)h"
    $gpoprocessevents | Where-Object { $ids -contains $_.Id } | ForEach-Object `
    {    
        $i++
        $templist += $_.ActivityId
        Write-Host "$i - $($_.Message) - $($_.TimeCreated)"
        Write-Host "------------"
    }  

    #Select which GPO processing you want to review in details
    do
    {
        [int] $select = Read-Host "Select Starting Event to analyse"
    } while ( $select -lt 0 -or $select -gt $i )
    $select--

    # sort event collected and keep those corresponding to the Activity ID of the GPO processing you have selected
    $analyse = $gpoprocessevents | Where-Object { $_.ActivityId -eq $templist[ $select ] }

    # Display those events for a live review with only event LevelDisplayName (criticity) and event message
    $analyse | Select-Object LevelDisplayName, Message | Format-Table -Wrap -AutoSize
          
    if ( $csv -eq $true )
    {     
        # if csv swithc is used Export those events in full details in a CSV file named "<computername>-<ActivityID-gpoprocessing.csv"
        $analyse |select Timecreated,id,message,activityid |ConvertTo-Csv -NoTypeInformation| set-content $computer-$($templist[ $select ])-gpoprocessing.csv
    }
    if ( $html -eq $true )
    {
        $analyse |select Timecreated,id,message,activityid| ConvertTo-Html | Set-Content -Path $computer-$($templist[ $select ])-gpoprocessing.html
    }
} else {
    Write-host "No GPO processing started within the last $($hours) hour(s)"
}
