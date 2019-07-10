# Variables
$SCCMSiteServer = 's-prd-ps-001.intra.phbern.ch'
$SCCMNamespace = 'Root\SMS\Site_P01'
$SiteCode = 'p01'

$OSDDeviceCollectionName = "OSD - Windows10_1903-201906-DEV"

# Import the SCCM powershell module
$CurrentLocation = Get-Location
Import-Module(Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)
Set-Location($SiteCode + ":")



#region Functions
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
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=2)] $MACAddress,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=1)] $SWProfile

    )
        #Validate MACAddress Format length = 17 and contains ":" and splita array = 5
        $MACAddress = $MACAddress.Trim()
        if (($MACAddress.Length -eq 17) -and ($MACAddress.Split(":").count -eq 6) -and $MACAddress.Contains(":"))
        {

            if ((Get-CMDevice -Name $DeviceName) -or ($DeviceName.Length -ne 7)) # Check Devicename M-12345
                {
                #Throw "$DeviceName already exist! No import possible!"
                [System.Windows.Forms.MessageBox]::Show("$DeviceName existiert bereits oder falsches Format","Computername",0)
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
                    Start-Sleep -Seconds 5
                    Update-CMDeviceCollection -DeviceCollectionName "All Systems" -Wait -Verbose

                    Add-CMDeviceCollectionDirectMembershipRule -CollectionName $OSDDeviceCollectionName -ResourceId $res.ResourceID

                    Update-CMDeviceCollection -DeviceCollectionName $OSDDeviceCollectionName -Wait -Verbose

                    New-CMDeviceVariable -DeviceName $DeviceName -VariableName "PHBProfile" -VariableValue $SWProfile -IsMask 0 
                    if (get-cmdeviceVariable -ResourceId $res.ResourceID -VariableName "PHBProfile")
                    {
                        Set-Location -Path "c:\"
                        [System.Windows.Forms.MessageBox]::Show("Fertig","Import",0)
                    }
                }
            }
            else {
                [System.Windows.Forms.MessageBox]::Show("MAC Adresse wurde im falschen Format eingegeben","MAC Adresse",0)
            }
} # end function

# ----------------------------------------------------------------------------- 
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
} # end function
 
#Start App~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    function Start-import {
        param (
            $MACAddress,
            $DeviceName,
            $SWProfile
        )
        import-cmdevice -DeviceCollectionName "OSD - Windows10_1903-201906-DEV" -DeviceName $DeviceName -MACAddress $MACAddress -SWProfile $SWProfile
        
    }
# ----------------------------------------------------------------------------- 
#endregion Functions


#region Constructor

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#endregion Constructor


#region FORM
#~~< Form1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Show-Gui{
    param(
        [switch]$Gui
    )

    if($Gui){

        # Gui total~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $objForm = New-Object System.Windows.Forms.Form 
        $objForm.Text = "PHBern - Import Computer"
        $objForm.Size = New-Object System.Drawing.Size(700,500) 
        $objForm.StartPosition = "CenterScreen"
        $objForm.MaximizeBox = $false
        $objForm.minimumSize = New-Object System.Drawing.Size(700,500) 
        $objForm.maximumSize = New-Object System.Drawing.Size(700,500)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       
        # Checkbox for Profiles - Verwaltung~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $chkVerwaltung = New-Object System.Windows.Forms.radiobutton
        $chkVerwaltung.Location = New-Object System.Drawing.Size(400,30)
        $chkVerwaltung.Size = New-Object System.Drawing.Size(200,80)
        $chkVerwaltung.Text = "Software Profile Verwaltung"
        $chkVerwaltung.Checked = $True
        $objForm.Controls.Add($chkVerwaltung)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        # Checkbox for Profiles - Dozierende~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $chkDozierende = New-Object System.Windows.Forms.radiobutton
        $chkDozierende.Location = New-Object System.Drawing.Size(400,90)
        $chkDozierende.Size = New-Object System.Drawing.Size(200,80)
        $chkDozierende.Text = "Software Profile Dozierende" 
        $objForm.Controls.Add($chkDozierende)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        # Checkbox for Profiles - Ultramobile~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $chkUltramobile = New-Object System.Windows.Forms.radiobutton
        $chkUltramobile.Location = New-Object System.Drawing.Size(400,150)
        $chkUltramobile.Size = New-Object System.Drawing.Size(200,80)
        $chkUltramobile.Text = "Software Profile Ultramobile"
        $objForm.Controls.Add($chkUltramobile)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        # Checkbox for Profiles - Pool~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $chkPool = New-Object System.Windows.Forms.radiobutton
        $chkPool.Location = New-Object System.Drawing.Size(400,210)
        $chkPool.Size = New-Object System.Drawing.Size(200,80)
        $chkPool.Text = "Software Profile Pool"
        $objForm.Controls.Add($chkPool)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        # Group for Software~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $GrpSW = New-Object System.Windows.Forms.GroupBox
        $GrpSW.Location = New-Object System.Drawing.Size(340,15)
        $GrpSW.Size = New-Object System.Drawing.Size(320,300)
        $GrpSW.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $GrpSW.Font = $Font1
        $GrpSW.Text = "Software Profile"
        $objForm.Controls.Add($GrpSW)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        # Label PC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $lblPC = New-Object System.Windows.Forms.Label
        $lblPC.Location = New-Object System.Drawing.Size(50,37)
        $lblPC.Size = New-Object System.Drawing.Size(200,100)
        $lblPC.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $lblPC.Font = $Font1
        $lblPC.Text = "Computername:"
        $objForm.Controls.Add($lblPC)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        # Textbox PCName~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $txtboxPC = New-Object System.Windows.Forms.Textbox
        $txtboxPC.Location = New-Object System.Drawing.Size(50,60)
        $txtboxPC.Size = New-Object System.Drawing.Size(200,100)
        $txtboxPC.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $txtboxPC.Font = $Font1
        $objForm.Controls.Add($txtboxPC)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        # Label MAC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $lblMAC = New-Object System.Windows.Forms.Label
        $lblMAC.Location = New-Object System.Drawing.Size(50,100)
        $lblMAC.Size = New-Object System.Drawing.Size(200,100)
        $lblMAC.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $lblMAC.Font = $Font1
        $lblMAC.Text = "Mac Adresse:"
        $objForm.Controls.Add($lblMAC)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        # Textbox MAC Address~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $txtboxMAC = New-Object System.Windows.Forms.Textbox
        $txtboxMAC.Location = New-Object System.Drawing.Size(50,123)
        $txtboxMAC.Size = New-Object System.Drawing.Size(200,100)
        $txtboxMAC.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $txtboxMAC.Font = $Font1
        $objForm.Controls.Add($txtboxMAC)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        # Group for Computer~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $GrpInfo = New-Object System.Windows.Forms.GroupBox
        $GrpInfo.Location = New-Object System.Drawing.Size(20,15)
        $GrpInfo.Size = New-Object System.Drawing.Size(300,300)
        $GrpInfo.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $GrpInfo.Font = $Font1
        $GrpInfo.Text = "Computer Daten"
        $objForm.Controls.Add($GrpInfo)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        $OKButtonStart = New-Object System.Windows.Forms.Button
        $OKButtonStart.Location = New-Object System.Drawing.Size(450,350)
        $OKButtonStart.Size = New-Object System.Drawing.Size(200,80)
        $OKButtonStart.Text = "Start import"
        $OKButtonStart.Add_Click({
                                 if ($chkVerwaltung.Checked){Start-import -DeviceName $txtboxPC.Text -MACAddress $txtboxMAC.Text -SWProfile "Verwaltung" }
                                 if ($chkDozierende.Checked){Start-import -DeviceName $txtboxPC.Text -MACAddress $txtboxMAC.Text -SWProfile "Dozierende" }
                                 if ($chkUltramobile.Checked){Start-import -DeviceName $txtboxPC.Text -MACAddress $txtboxMAC.Text -SWProfile "Verwaltung" }
                                 if ($chkPool.Checked){Start-import -DeviceName $txtboxPC.Text -MACAddress $txtboxMAC.Text -SWProfile "Pool-1" }
                                })

        $objForm.Controls.Add($OKButtonStart)

        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

       
        # Show the dialog
        [void] $objForm.ShowDialog()
        
    }
}
#endregion FORM

#region MAIN

    Show-Gui -Gui

    