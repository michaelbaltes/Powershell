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

        # Form Dropdown for Computer~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        $Dropdown = New-Object System.Windows.Forms.ComboBox
        $Dropdown.Location = New-Object System.Drawing.Size(20,350)
        $Dropdown.Size = New-Object System.Drawing.Size(300,50)
        $Dropdown.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $Dropdown.Font = $Font1
        $Dropdown.Text = "Collection Name"

        #Add Item List to Dropdown
        [array]$Coll = "OSD1","OSD2"

        foreach ($i in $coll){$Dropdown.Items.Add($i)}

        $objForm.Controls.Add($Dropdown)
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

Show-Gui -Gui 