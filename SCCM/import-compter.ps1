# Variables
$SCCMSiteServer = 's-prd-ps-001.intra.phbern.ch'
$SCCMNamespace = 'Root\SMS\Site_P01'
$SiteCode = 'p01'

$MACAddress = '00:11:22:33:44:55'
$DeviceName = 'PCNAME001'
$OSDDeviceCollectionName = "OSD - Windows10_1903-201906-DEV"

# Import the SCCM powershell module
$CurrentLocation = Get-Location
Import-Module(Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)
Set-Location($SiteCode + ":")




function import-cmdevice 
{
    <# 
    .Synopsis 
       Create device and put to OSD Collection
    .DESCRIPTION 
       import new device to "All systems" and to 2nd Collection like OSD
    .EXAMPLE 
       import-cmdevice -DeviceCollectionName "All Workstations" 
    #> 
    param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)] $DeviceCollectionName,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)] $DeviceName,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=2)] $MACAddress

    )
    
        if (Get-CMDevice -Name $DeviceName)
            {
            Throw "$DeviceName already exist! No import possible!"
            }
        else
            {
                # create computer
                $wmiconnection = ([WMIClass]"\\$SCCMSiteServer\root\SMS\Site_$($Sitecode):SMS_Site")
                $newclient = $wmiconnection.psbase.GetMethodParameters("ImportMachineEntry")
                $newclient.MACAddress = $MACAddress
                $newclient.NetbiosName = $DeviceName
                $newclient.OverwriteExistingRecord = $true
                $res = $wmiconnection.psbase.InvokeMethod("ImportMachineEntry",$newclient,$null)
                
                Update-CMDeviceCollection -DeviceCollectionName "All Systems" -Wait -Verbose

                $resoureID = Get-CMDevice -Name $DeviceName | select ResourceID
                Add-CMDeviceCollectionDirectMembershipRule -CollectionName $OSDDeviceCollectionName -ResourceId $resoureID.ResourceID

                Update-CMDeviceCollection -DeviceCollectionName $OSDDeviceCollectionName -Wait -Verbose
            }
   }

    Function Update-CMDeviceCollection
{ 
    <# 
    .Synopsis 
       Update SCCM Device Collection 
    .DESCRIPTION 
       Update SCCM Device Collection. Use the -Wait switch to wait for the update to complete. 
    .EXAMPLE 
       Update-CMDeviceCollection -DeviceCollectionName "All Workstations" 
    .EXAMPLE 
       Update-CMDeviceCollection -DeviceCollectionName "All Workstations" -Wait -Verbose 
    #> 
 
    [CmdletBinding()] 
    [OutputType([int])] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   Position=0)] 
        $DeviceCollectionName, 
        [Switch]$Wait 
    ) 
 
    Begin 
    { 
        Write-Verbose "$DeviceCollectionName : Update Started" 
    } 
    Process 
    { 
        $Collection = Get-CMDeviceCollection -Name $DeviceCollectionName 
        $null = Invoke-WmiMethod -Path "ROOT\SMS\Site_$($SiteCode):SMS_Collection.CollectionId='$($Collection.CollectionId)'" -Name RequestRefresh -ComputerName $SCCMSiteServer 
    } 
    End 
    { 
        if($Wait) 
        { 
            While($(Get-CMDeviceCollection -Name $DeviceCollectionName | Select -ExpandProperty CurrentStatus) -eq 5) 
            { 
                Write-Verbose "$DeviceCollectionName : Updating..." 
                Start-Sleep -Seconds 5 
            } 
            Write-Verbose "$DeviceCollectionName : Update Complete!" 
        } 
    } 
} 
 
# ----------------------------------------------------------------------------- 
# MAIN

import-cmdevice -DeviceCollectionName "OSD - Windows10_1903-201906-DEV" -DeviceName "MBATEST" -MACAddress '00:11:22:33:44:55'