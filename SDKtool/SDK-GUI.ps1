<#
# +--------------------------------------------------------------------------------------------------+
# | File    : SDK.ps1                                                                                |
# | Author  : Michael Baltes (PHBern)                                      |
# | Version : 1.3                                                                                    |
# | Purpose : Ziel ist es dem Anwender eine GUI mit relevanten Informationen zur Verfügung zu stellen|
# |           Ausserdem soll es für das ServiceDesk möglich sein Informationen remote zu sammeln     |
# |                                                                                                  |
# | Synopsis: Unter Angabe des Computername werde Infos gesammelt                                    |
# | Usage   : einfach starten oder mit SDK-GUI.ps1 f69666 "PC Name" Fuer Remote                      |
# +--------------------------------------------------------------------------------------------------+
# | Maintenance History                                                                              |
# | -------------------                                                                              |
# | Name             Date            Version      Description                                        |
# | -------------------------------------------------------------------------------------------------+
# | Michael Baltes   24-11-2014      0.1          Initial Version                                    |
# | Michael Baltes   19.12.2014      0.2          GUI Anpassng und Erweiterungen                     |
# | Michael Baltes   05.01.2015      0.3          Funktionen erweitert                               |
# | Michael Baltes   09.01.2015      0.3.3        zip funktion neu und collect files                 |
# | Michael Baltes   12.01.2015      0.3.4        Merge Charly (Userinfo) un Michael funktionen      |
# | Michael Baltes   12.01.2015      0.3.5        Errorhandling angepasst                            |
# | Michael Baltes   23.01.2015      0.3.7        Fehlerbereinig und Icon                            |
# | Michael Baltes   23.01.2015      0.3.8        Errorhandling                                      |
# | Michael Baltes   23.01.2015      0.3.8        Driveletter O:                                     |
# | Michael Baltes   25.02.2015      0.4.2        Ad Query anpassen und Client Auslesen added        |
# |                                                                                                  |
# +--------------------------------------------------------------------------------------------------+
#>
#----------------------------------------------------------------------------------------------------|
#----------------------------------------------------------------------------------------------------|
# 
#----------------------------------------------------------------------------------------------------|
# Check for Script Requirements

if ( ($PSVersionTable.CLRVersion.Major -le 3) -or ($PSVersionTable.PSVersion.Major -le 2)){
 [System.Windows.Forms.MessageBox]::Show("Powershell Voraussetzungen leider nicht erfüllt!!")
}
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
#----------------------------------------------------------------------------------------------------|

#region GUI - START
#----------------------------------------------------------------------------------------------------|
#Loading Assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

function get-checkbox{
    
    # Set the size of your form
    $FormCheck = New-Object System.Windows.Forms.Form
    $FormCheck.Startposition = "CenterScreen"
    $FormCheck.width = 300
    $FormCheck.height = 230
    $FormCheck.Text = "SDK - ServiceTool"
    $FormCheck.MaximizeBox = $false
    $FormCheck.minimumSize = New-Object System.Drawing.Size(300,230) 
    $FormCheck.maximumSize = New-Object System.Drawing.Size(300,230)
 
    $Icon = New-Object system.drawing.icon ($PSScriptRoot + "\phbern_git.ico")
    $FormCheck.Icon = $Icon 

    # Set the font of the text to be used within the form
    $Font = New-Object System.Drawing.Font("Arial",11)
    $FormCheck.Font = $Font

    $LabelFont = New-Object System.Drawing.Font("Arial",10)
    $Label = New-Object System.Windows.Forms.Label
    $Label.Location = new-object System.Drawing.Size(30,55)
    $Label.Font = $LabelFont
    $Label.Text = "Bitte FQDN des`r`nZielcomputers eingeben:"
    $Label.AutoSize = $True
    $Label.Enabled = $true
    $Label.Visible = $false
    $FormCheck.Controls.Add($Label)


    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location = new-object System.Drawing.Size(30,100)
    $textbox.Size = new-object System.Drawing.Size(225,100)
    $textbox.enabled = $false
    $textbox.Text = ""
    $textbox.Visible = $true

    $FormCheck.Controls.Add($textbox)

    # create your checkbox 
    $checkbox1 = new-object System.Windows.Forms.checkbox
    $checkbox1.Location = new-object System.Drawing.Size(30,25)
    $checkbox1.Size = new-object System.Drawing.Size(100,25)
    $checkbox1.Text = "Remote"
    $checkbox1.Checked = $false
    $FormCheck.Controls.Add($checkbox1)
    
    # create your checkbox 
    $checkbox2 = new-object System.Windows.Forms.checkbox
    $checkbox2.Location = new-object System.Drawing.Size(190,25)
    $checkbox2.Size = new-object System.Drawing.Size(100,25)
    $checkbox2.Text = "Local"
    $checkbox2.Checked = $false
    $FormCheck.Controls.Add($checkbox2)   
 
    # Add an OK button
    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = new-object System.Drawing.Size(60,140)
    $OKButton.Size = new-object System.Drawing.Size(80,30)
    $OKButton.Font = $Font
    $OKButton.Text = "OK"
    $OKButton.Add_Click({
        if($checkbox1.Checked -and $checkbox2.Checked -eq $true){
            [System.Windows.Forms.MessageBox]::Show("Es kann nur eine Checkbox zur gleichen Zeit ausgewählt werden!" , "Fehler")
        }elseif($checkbox1.Checked -eq $true){
            $script:runremote = $true
            $script:runremote
            if($textbox.text -match "(\w\.\w)"){
                $script:strFQDN=$textbox.text
                $FormCheck.Close()
            }
            else{
                [System.Windows.Forms.MessageBox]::Show("Der Computername muss als FQDN`r`nim Format x.y.z angegeben werden! " , "Fehler")
            }
        }elseif($checkbox2.Checked -eq $true){
            $script:runremote = $false
            $script:runremote
            $FormCheck.Close()
        }else{
            [System.Windows.Forms.MessageBox]::Show("Damit das SDK Tool starten kann,`r`nmuss eine Option ausgewählt werden!" , "Fehler")
        }
    })

    $FormCheck.Controls.Add($OKButton)
 
    #Add a cancel button
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = new-object System.Drawing.Size(150,140)
    $CancelButton.Size = new-object System.Drawing.Size(80,30)
    $CancelButton.Font = $Font
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click({$FormCHeck.Close()})
    $FormCheck.Controls.Add($CancelButton)

    $checkbox1.add_CheckStateChanged({
        $textbox.enabled = $checkbox1.checked
        $Label.Visible = $checkbox1.checked
    })
    
    # Activate the form
    $FormCheck.Add_Shown({$FormCheck.Activate()})
    [void] $FormCheck.ShowDialog()
    
}

function Show-Gui{
    param(
        [switch]$Gui
    )

    if($Gui){

        # Gui total
        $objForm = New-Object System.Windows.Forms.Form 
        $objForm.Text = "SDK - ServiceTool"
        $objForm.Size = New-Object System.Drawing.Size(900,600) 
        $objForm.StartPosition = "CenterScreen"
        $objForm.MaximizeBox = $false
        $objForm.minimumSize = New-Object System.Drawing.Size(900,600) 
        $objForm.maximumSize = New-Object System.Drawing.Size(900,600)

        # -------------------------------------------------------------------
        # Label "Statusanzeige für Progressbar"
        $objLabel = New-Object System.Windows.Forms.Label
        $objLabel.Location = New-Object System.Drawing.Size(670,520)
        $objLabel.Size = New-Object System.Drawing.Size(280,20)
        $objLabel.Visible = $false
        $objForm.Controls.Add($objLabel) 

        # -------------------------------------------------------------------
        # Button 1 "Detallierte Informationen"
        $OKButtonInfo = New-Object System.Windows.Forms.Button
        $OKButtonInfo.Location = New-Object System.Drawing.Size(670,20)
        $OKButtonInfo.Size = New-Object System.Drawing.Size(200,80)
        $OKButtonInfo.Text = "Detallierte Informationen"
        $OKButtonInfo.Add_Click({Start-detail})

        $objForm.Controls.Add($OKButtonInfo)

        # -------------------------------------------------------------------
        # Button 2 Link zum Snipping
        $OKButtonSnip = New-Object System.Windows.Forms.Button
        $OKButtonSnip.Location = New-Object System.Drawing.Size(670,120)
        $OKButtonSnip.Size = New-Object System.Drawing.Size(200,80)
        $OKButtonSnip.Text = "Snipping Tool$( [System.Environment]::NewLine )Das Erstellen von PrintScreens"
        $OKButtonSnip.Add_Click({Start-App "snp"})

        $objForm.Controls.Add($OKButtonSnip)

        # -------------------------------------------------------------------
        # Button 3 Link zum ProblemStepRecorder
        $OKButtonStepRec = New-Object System.Windows.Forms.Button
        $OKButtonStepRec.Location = New-Object System.Drawing.Size(670,220)
        $OKButtonStepRec.Size = New-Object System.Drawing.Size(200,80)
        $OKButtonStepRec.Text = "Problem Step Recorder$( [System.Environment]::NewLine )Aufzeichnung der Schritte,$( [System.Environment]::NewLine )welche zum Problem führen"
        $OKButtonStepRec.Add_Click({Start-App "psr"})

        $objForm.Controls.Add($OKButtonStepRec)

        # -------------------------------------------------------------------
        # Listview - Infos
        $objListBox = New-Object System.Windows.Forms.ListBox 
        $objListBox.Location = New-Object System.Drawing.Size(30,35) 
        $objListBox.Size = New-Object System.Drawing.Size(610,470) 
        $objListBox.Height = 470
        $Font = New-Object System.Drawing.Font("Arial",13,[System.Drawing.FontStyle]::Regular)
        $objListBox.Font= $Font
        $objListbox.SelectionMode = "MultiExtended"
        $arrInfo=get-basics -Computer $computer -localPC

        Foreach ($info in $arrInfo){
            [void] $objListBox.Items.Add("")
            [void] $objListBox.Items.Add($info)

        }

        # Add data to listbox
        $objForm.Controls.Add($objListBox)

        # -------------------------------------------------------------------
        # Group
        $GrpInfo = New-Object System.Windows.Forms.GroupBox
        $GrpInfo.Location = New-Object System.Drawing.Size(20,15)
        $GrpInfo.Size = New-Object System.Drawing.Size(630,490)
        $GrpInfo.AutoSize = $True
        $Font1 = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        $GrpInfo.Font = $Font1
        $GrpInfo.Text = "Informationen"

        $objForm.Controls.Add($GrpInfo)
        # -------------------------------------------------------------------

        # -------------------------------------------------------------------
        # Checkbox
        $chkGPO = New-Object System.Windows.Forms.CheckBox
        $chkGPO.Location = New-Object System.Drawing.Size(670,300)
        $chkGPO.Size = New-Object System.Drawing.Size(200,80)
        $chkGPO.Text = "Extented GPO Information"

        $objForm.Controls.Add($chkGPO)
        # -------------------------------------------------------------------

        # -------------------------------------------------------------------
        # Icon
        $Icon = New-Object system.drawing.icon ($PSScriptRoot + "\phbern_git.ico")
        $objForm.Icon = $Icon 
        # -------------------------------------------------------------------

        # -------------------------------------------------------------------
        # Progressbar
        $progressBar1 = New-Object System.Windows.Forms.ProgressBar
        $progressBar1.Name = 'progressBar1'
        $progressBar1.Value = 0
        $progressBar1.Style = "Continuous"
        $progressBar1.Visible = $false

        $progressBar1.Location = New-Object System.Drawing.Size(20,520)
        $progressBar1.size = New-Object System.Drawing.Size(630,30)

        #Finally, like the other controls, the progress bar needs to be added to the form.
        $objForm.Controls.Add($progressBar1)
        # -------------------------------------------------------------------

        # Show the dialog
        [void] $objForm.ShowDialog()

    }
}
# -------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------|
#endregion
# GUI - END 

#----------------------------------------------------------------------------------------------------|
#----------------------------------------------------------------------------------------------------|


#region FUNCTIONS - START
#----------------------------------------------------------------------------------------------------|

Function Write-Log {
		[CmdletBinding()]
		param([String]$LogText,
		[switch]$WriteToFile
		,
		[string]$LogFilePath,
		[string]$Encoding = "UTF8",
		[Switch]$Append
		)
        $LogText = "$(get-date -Format HH:mm.ss)" + " - $LogText"
		Write-Verbose $LogText
		if ($WriteToFile) {
			Out-File -FilePath $LogFilePath -InputObject $LogText -Encoding:$Encoding -Append:$Append -Whatif:$false
		}
	}

function get-basics {
param
    (
    $Computer,
    [Switch]$BasicsToFile,
    [Switch]$localPC
    )

Try{
    Write-Log -LogText $(" +++ Connect to WMI of Computer: " + $Computer + " and User: " + $global:usrLogedOn + " - (get-basics)" ) -WriteToFile -LogFilePath $LogFileFullpath -Append
    Write-Log -LogText $(" +++ Connect to WMI of Computer: " + $Computer + " Win32_Computersystem") -WriteToFile -LogFilePath $LogFileFullpath -Append
    $Computersystem = Get-WmiObject Win32_Computersystem -ComputerName $Computer
    Write-Log -LogText $(" +++ Connect to WMI of Computer: " + $Computer + " Win32_NetworkAdapterConfiguration") -WriteToFile -LogFilePath $LogFileFullpath -Append
    $net = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer | ?{$_.DHCPEnabled -eq $TRUE} | select IPAddress 
    Write-Log -LogText $(" +++ Connect to WMI of Computer: " + $Computer + " win32_operatingsystem") -WriteToFile -LogFilePath $LogFileFullpath -Append
    $OS = Get-WmiObject win32_operatingsystem -ComputerName $Computer
    $cap = ""
    Write-Log -LogText $(" +++ Connect to WMI of Computer: " + $Computer + " Win32_PhysicalMemory") -WriteToFile -LogFilePath $LogFileFullpath -Append
    $memory = Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $Computer | %{[int]$cap=$cap+$_.capacity / (1024*1024)};$memory=$cap
    Write-Log -LogText $(" +++ Connect to WMI of Computer: " + $Computer + " Connect to WMI Win32 ended...") -WriteToFile -LogFilePath $LogFileFullpath -Append
    $arrBaseInfo=@()
    
    $scriptblock = 
        {
            #Write-Log -LogText $(" +++ Drive Information: " + $Computer + " Disc Informationen") -WriteToFile -LogFilePath $LogFileFullpath -Append
	        $zDrives = [system.io.Driveinfo]::getdrives() | where { ($_.DriveType -eq "Fixed") -and ($_.IsReady -eq "True") }
            #Write-Log -LogText $(" +++ Drive Information: " + $Computer + "found " + $zdrives.Count) -WriteToFile -LogFilePath $LogFileFullpath -Append
	        $zDrives | foreach { 
		                $driveLetter = $_.name
		                $drive = $NULL
		                $drive= New-Object system.io.driveinfo("$driveLetter")
		                $percentFree = $drive.TotalFreeSpace/$drive.TotalSize *100
		                $percentFreeFormatiert = "{0:0}" -F $percentFree
                        $driveInfo = @()
                        $driveInfo += "Laufwerk: " + $driveLetter
		                $driveInfo += "Freier Speicherplatz: " + [Math]::Round($drive.TotalFreeSpace / (1024*1024)) + " MB / " + $percentFreeFormatiert + "%"
	                    $driveInfo += "Gesamt Speicherplatz: " + [Math]::Round($drive.TotalSize / (1024*1024)) + " MB"
                        $driveInfo += ""
                        $driveInfo
            }                   
          
        }

    if($localPC.IsPresent){
        $hdd=$scriptblock.Invoke()
        
        #Lokaler Admin
        if ($(whoami /groups) -match "(S-1-5-32-544)"){
            $locAdm = "Ja"
        } else {
            $locAdm = "Nein"
        }
    }
    elseif($global:objcomp.FQDN -eq ((Get-WmiObject Win32_Computersystem).Name + "." + (Get-WmiObject Win32_Computersystem).Domain)){
        #Fals das Skript in der PS ausgeführt wird und der lokale Client das Ziel ist
        $hdd=$scriptblock.Invoke()
    }
    else{
        $hdd=Invoke-Command -ComputerName $Computer -ScriptBlock $scriptblock
    } 

    #GUI Informationen
    $arrBaseInfo+="Benutzername: "     +    $global:usrLogedOn
    if($locAdm){$arrBaseInfo+="Lokaler Admin: " +  $locAdm}
    $arrBaseInfo+="Computername: " +    $Computersystem.Name
    $arrBaseInfo+="Computer Modell: " +   $Computersystem.Manufacturer + " - " + $Computersystem.Model
    $arrBaseInfo+="Computer Domäne: " +  $Computersystem.Domain
    $arrBaseInfo+="Ip Adresse: " + $net.IpAddress
    #bai 22.03
    #$arrBaseInfo+="Last Boot Time: " + ($OS | select @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}).lastbootuptime
    #$arrBaseInfo+="Last Logon User Time: " + (Get-EventLog -ComputerName $Computer -LogName SYSTEM -EntryType Information -Source Microsoft-Windows-Winlogon -Newest 1 -InstanceId 7001).TimeGenerated

    $arrBaseInfo+="Last Boot Time: " + $($OS | select @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}).lastbootuptime
    $arrBaseInfo+="Last Logon User Time: " + $(Get-EventLog -ComputerName $Computer -LogName SYSTEM -EntryType Information -Source Microsoft-Windows-Winlogon -Newest 1 -InstanceId 7001).TimeGenerated

    $arrBaseInfo+="PHBern Version: " + $(get-BasicInfo -Computer $Computer).OSImageVersion # Function name changed and get OSImageVersion instead Version, bai 22.03
    
    if($BasicsToFile.isPresent){
        #GUI Infos plus Memory und Disk für Out-File
        $arrFileInfo=@()
        $arrFileInfo+=""
        $arrFileInfo+="Memory: " + $memory
        $arrFileInfo+="Diskinformationen:"
        $arrFileInfo+=""
        $arrFileInfo+=$hdd        
        
        $arrBaseInfo | Out-File $($tmpFolder + "\PCInfo_" + $Computer + "_" + $strDate + ".log") -Append
        $arrFileInfo | Out-File $($tmpFolder + "\PCInfo_" + $Computer + "_" + $strDate + ".log") -Append
        #$hdd | Out-File $($tmpFolder + "\PCInfo_" + $Computer + "_" + $strDate + ".log") -Append

    }
    else {
        $arrBaseInfo      

    }


    }
    Catch{
        Write-Log -LogText $(" --- Connect to WMI of Computer: " + $Computer + " failed!") -WriteToFile -LogFilePath $LogFileFullpath -Append
        Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append  
    }   


    
}

function Start-App {
    param(
        [parameter(Mandatory=$True)]
        $strApp
    )
    Write-Log -LogText $(" +++ Starting App on " + $Computer + " and User: " + $env:USERNAME + " - (Start-App)" ) -WriteToFile -LogFilePath $LogFileFullpath -Append
    $strTextMsg="Unter dem angegebenen Pfad kann keine ausführbare Datei gefunden werden!"
    $strTextMsg1="Für die betreffende Applikation wurde kein Pfad angegeben!"

    if ($arrAppPaths.ContainsKey($strApp)){
        $strPathApp=$arrAppPaths.($strApp)
        if(Test-Path $strPathApp){
            & $strPathApp                    
        } else {
            [System.Windows.Forms.MessageBox]::Show($strTextMsg)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show($strTextMsg1)
    }


}

Add-Type -As System.IO.Compression.FileSystem

function New-ZipFile {
	#.Synopsis
	#  Create a new zip file, optionally appending to an existing zip...
	[CmdletBinding()]
	param(
		# The path of the zip to create
		[Parameter(Position=0, Mandatory=$true)]
		$ZipFilePath,
 
		# Items that we want to add to the ZipFile
		[Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		[Alias("PSPath","Item")]
		[string[]]$InputObject = $Pwd,
 
		# Append to an existing zip file, instead of overwriting it
		[Switch]$Append,
 
		# The compression level (defaults to Optimal):
		#   Optimal - The compression operation should be optimally compressed, even if the operation takes a longer time to complete.
		#   Fastest - The compression operation should complete as quickly as possible, even if the resulting file is not optimally compressed.
		#   NoCompression - No compression should be performed on the file.
		[System.IO.Compression.CompressionLevel]$Compression = "Optimal"
	)
	begin {
		# Make sure the folder already exists
		[string]$File = Split-Path $ZipFilePath -Leaf
		[string]$Folder = $(if($Folder = Split-Path $ZipFilePath) { Resolve-Path $Folder } else { $Pwd })
		$ZipFilePath = Join-Path $Folder $File
		# If they don't want to append, make sure the zip file doesn't already exist.
		if(!$Append) {
			if(Test-Path $ZipFilePath) { Remove-Item $ZipFilePath }
		}
		$Archive = [System.IO.Compression.ZipFile]::Open( $ZipFilePath, "Update" )
	}
	process {
		foreach($path in $InputObject) {
			foreach($item in Resolve-Path $path) {
				# Push-Location so we can use Resolve-Path -Relative
				Push-Location (Split-Path $item)
				# This will get the file, or all the files in the folder (recursively)
				foreach($file in Get-ChildItem $item -Recurse -File -Force | % FullName) {
					# Calculate the relative file path
					$relative = $(Resolve-Path $file -Relative).TrimStart(".\")
					# Add the file to the zip
					$null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($Archive, $file, $relative, $Compression)
				}
				Pop-Location
			}
		}
	}
	end {
		$Archive.Dispose()
		Get-Item $ZipFilePath
	}
}
     
     
function Expand-ZipFile {
	#.Synopsis
	#  Expand a zip file, ensuring it's contents go to a single folder ...
	[CmdletBinding()]
	param(
		# The path of the zip file that needs to be extracted
		[Parameter(ValueFromPipelineByPropertyName=$true, Position=0, Mandatory=$true)]
		[Alias("PSPath")]
		$FilePath,
 
		# The path where we want the output folder to end up
		[Parameter(Position=1)]
		$OutputPath = $Pwd,
 
		# Make sure the resulting folder is always named the same as the archive
		[Switch]$Force
	)
	process {
		$ZipFile = Get-Item $FilePath
		$Archive = [System.IO.Compression.ZipFile]::Open( $ZipFile, "Read" )
 
		# Figure out where we'd prefer to end up
		if(Test-Path $OutputPath) {
			# If they pass a path that exists, we want to create a new folder
			$Destination = Join-Path $OutputPath $ZipFile.BaseName
		} else {
			# Otherwise, since they passed a folder, they must want us to use it
			$Destination = $OutputPath
		}
 
		# The root folder of the first entry ...
		$ArchiveRoot = ($Archive.Entries[0].FullName -Split "/|\\")[0]
 
		Write-Verbose "Desired Destination: $Destination"
		Write-Verbose "Archive Root: $ArchiveRoot"
 
		# If any of the files are not in the same root folder ...
		if($Archive.Entries.FullName | Where-Object { @($_ -Split "/|\\")[0] -ne $ArchiveRoot }) {
			# extract it into a new folder:
			New-Item $Destination -Type Directory -Force
			[System.IO.Compression.ZipFileExtensions]::ExtractToDirectory( $Archive, $Destination )
		} else {
			# otherwise, extract it to the OutputPath
			[System.IO.Compression.ZipFileExtensions]::ExtractToDirectory( $Archive, $OutputPath )
 
			# If there was only a single file in the archive, then we'll just output that file...
			if($Archive.Entries.Count -eq 1) {
				# Except, if they asked for an OutputPath with an extension on it, we'll rename the file to that ...
				if([System.IO.Path]::GetExtension($Destination)) {
					Move-Item $(Join-Path $OutputPath $Archive.Entries[0].FullName) $Destination
				} else {
					Get-Item $(Join-Path $OutputPath $Archive.Entries[0].FullName)
				}
			} elseif($Force) {
				# Otherwise let's make sure that we move it to where we expect it to go, in case the zip's been renamed
				if($ArchiveRoot -ne $ZipFile.BaseName) {
					Move-Item $(join-path $OutputPath $ArchiveRoot) $Destination
					Get-Item $Destination
				}
			} else {
				Get-Item $(Join-Path $OutputPath $ArchiveRoot)
			}
		}
 
		$Archive.Dispose()
	}
}


Function Create-Folder{
      param(
        [Parameter(Mandatory=$True)][string]$savefolder
      )

      if (Test-Path -Path $savefolder){
        return $True | Out-Null
      }
      else{
        New-Item -Path $savefolder -ItemType Directory -ErrorAction Stop 
      }

}

Function Check-OS
{
# get the OS Version to check Server or client
    param(
        $Computer
    )

    try{
       Write-Log -LogText $(" +++ Starting to get OS of Computer: " + $Computer + " - (Check-OS)") -WriteToFile -LogFilePath $LogFileFullpath -Append 
       Get-WmiObject win32_operatingsystem -ComputerName $Computer | select ProductType, Caption, Version, OSArchitecture
       Get-WmiObject win32_computersystem  | select Systemtype 
    }
    catch{
        Write-Log -LogText $(" --- Failed to connect to WMI of Computer: " + $Computer) -WriteToFile -LogFilePath $LogFileFullpath -Append 
    }
}

function Get-UserInfos{
    param(
        [Parameter(Mandatory=$True)][string]$LoggedOnUser,
        [Parameter(Mandatory=$True)][string]$Computer
      )

      try{
        Write-Log -LogText " +++ Start running on $computer to find $LoggedOnUser Profile Settings - (Get-UserInfos)" -WriteToFile -LogFilePath $LogFileFullpath -Append  
        $objADObj=([adsisearcher]"(&(objectCategory=User)(SamAccountName=$LoggedOnUser))")
        $objADObj.SearchScope="Subtree"
        $objADObj.propertiestoload.add("name") | Out-Null
        $objADObj.propertiestoload.add("distinguishedname") | Out-Null
        $objADObj.propertiestoload.add("lastlogon") | Out-Null
        $objADObj=$objADObj.FindOne()
        
                        
        #Get-WmiObject -ComputerName $Computer -Class Win32_NetworkLoginProfile |?{$_.caption -match $LoggedOnUser -and $_.UserType -ne $NULL} | select *
        $Shares = Get-WmiObject -ComputerName $Computer -Class Win32_NetworkConnection | Format-Table -AutoSize
        $time=echo $objADObj.properties.lastlogon
        $LogonTime =  [datetime]::FromFileTimeUtc($time)

        "`r`nFolgenden Netzlaufwerke hat der Benutzer angebunden:`n" | Out-File $($tmpFolder + "\UserInfo_" + $LoggedOnUser + "_" + $strDate + ".log") -Append 
        $Shares | Out-File $($tmpFolder + "\UserInfo_" + $LoggedOnUser + "_" + $strDate + ".log") -Append

        "`r`nLetzte erfolgreiche Anmeldung:`n" | Out-File $($tmpFolder + "\UserInfo_" + $LoggedOnUser + "_" + $strDate + ".log") -Append 
        $LogonTime | Out-File $($tmpFolder + "\UserInfo_" + $LoggedOnUser + "_" + $strDate + ".log") -Append


      }
      catch [DivideByZeroException]{
         Write-Log -LogText " --- Cannot find any user running on $computer with UserName $LoggedOnUser" -WriteToFile -LogFilePath $LogFileFullpath -Append  
         Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
      }
     

}

function convertfromDMTF-time{
    [CmdletBinding()]
    [OutputType([String])]
    Param(
        # Hilfebeschreibung zu Param1
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $timeToconvert


    )

    Begin{
        # Converts a given DMTF datetime to [DateTime]. 
        # The returned DateTime will be in the current 
        # time zone of the system.
        $dmtf = [System.Management.ManagementDateTimeConverter]

        Write-Output "Starting to convert given Time!"
    }
    Process{
    
        # convert CIM_DATETIME properties to .NET DateTime
        # objects and write them object back to the pipeline
        foreach($t in $timeToconvert){
            $convertedTime = $dmtf::ToDateTime($t)
            $convertedTime 
        }    

    }
    End{
        Write-Output "Ending to convert given Time!"
    }
}

function get-runningProcesses{
      param(
        
        [Parameter(Mandatory=$True)][string]$Computer
      )
      Write-Log -LogText " +++ Starting to get processes on $computer. - (get-runningProcesses)" -WriteToFile -LogFilePath $LogFileFullpath -Append      
      try{
        get-process -ComputerName $Computer | Out-File $($tmpFolder + "\Process_" + $Computer + "_" + $strDate + ".log")
      }
      catch{
        Write-Log -LogText " --- Cannot find processes on $computer or save in sererate Log File." -WriteToFile -LogFilePath $LogFileFullpath -Append
        Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
      }
}

function get-profileSize{
       param(
        [Parameter(Mandatory=$True)][string]$Computer
       )
       Write-Log -LogText " +++ Starting to get profile size on $computer. - (get-profileSize)" -WriteToFile -LogFilePath $LogFileFullpath -Append 
       try{
            Write-Log -LogText " +++ Starting to get profile path on $computer." -WriteToFile -LogFilePath $LogFileFullpath -Append
            Write-Log -LogText " +++ Reading profilesize of $profilepath ..." -WriteToFile -LogFilePath $LogFileFullpath -Append 
            $(get-childitem $profilepath -Recurse -force  -ErrorAction silentlycontinue | Measure-Object -Property length -Sum -Maximum -ErrorAction Continue).Sum / 1MB
       }
       catch{
            Write-Log -LogText " --- Cannot get Profilesize of $profilepath ." -WriteToFile -LogFilePath $LogFileFullpath -Append
            Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
       }
} 

function get-GPresult{
    try{
        Write-Log -LogText " +++ Getting Group Policy Information for $computer. - (get-GPresult)" -WriteToFile -LogFilePath $LogFileFullpath -Append
        gpresult /H ($tmpFolder + "\GPresult_" + $global:usrLogedOn + "_" + $strDate + ".html") /F
    }
    catch{
        Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append
    }
}

function get-ADGroups{
            param([ValidateNotNullOrEmpty()]
				  [psobject]$Computerobject,
				  [ValidateNotNullOrEmpty()]
				  [psobject]$Userobject,
                  [switch]$UserInfo
            )
				  
			<#
                Durchsucht sämtliche AD Gruppen nach der Mitgliedschaft des agegebenen Computers 
                und sammelt diese in dem Array $arrGrp    
            #>
            Write-Log -LogText " +++ Starting to get ADGroups. - (get-ADGroups)" -WriteToFile -LogFilePath $LogFileFullpath -Append
			try{
			    if (!($Computerobject -or $Userobject)){
				    Write-Error "At least one Parameter must be specified!"
				    return
    			}
                elseif ($Computerobject -and $Userobject){
		    		Write-Error "There can only be one Parameter at once!"
			    	return
			    }

			    if($Userobject){
                    $User=$Userobject.Username
                    $objADObj=([adsisearcher]"(&(objectCategory=User)(SamAccountName=$User))")
                    $DN=$Userobject.DirectoryEntry
                    $objsname=$User
                    $helper= $true
					Write-Log -LogText " +++ Getting AD Object $User - (get-ADGroups)" -WriteToFile -LogFilePath $LogFileFullpath -Append
			    }
			    else{
                    $Computer=$Computerobject.FQDN
                    $objADObj=([adsisearcher]"(&(objectCategory=computer)(dNSHostName=$Computer))")
                    $DN=$Computerobject.DirectoryEntry
                    $objsname=$Computer
                    $helper = $false
                    Write-Log -LogText " +++ Getting AD Object $Computer - (get-ADGroups)" -WriteToFile -LogFilePath $LogFileFullpath -Append

			    }
								
                $objADObj.SearchRoot=$DN
                $objADObj.SearchScope="Subtree"
                $objADObj=$objADObj.FindOne()
                $objname=$objADObj.Properties.distinguishedname
                $arrADGroups = $($objADObj.GetDirectoryEntry()).memberof                

                if ($Userobject -and ($User -ne $null)){
                    $hshInfo=@{expression={$objADObj.Properties.title};label="Titel"},
                             @{expression={$objADObj.Properties.sn};label="Name"},
                             @{expression={$objADObj.Properties.givenname};label="Vorname"},
                             @{expression={$objADObj.Properties.mail};label="E-Mail"}
                    Write-Log -LogText " +++ Getting Userinfo for $User. - (get-ADGroups)" -WriteToFile -LogFilePath $LogFileFullpath -Append
                    $arrGrp = @()
                    $arrGrp +=@("`r`nBenutzerinformationen von " + $User + ":")
                    $arrGrp +=$objADObj | fl $hshInfo
                }
                elseif($Userobject -and !($User)){
                    Write-Error "No User has been specified!"
			    	return
                }                         
                                

                Write-Log -LogText " +++ Getting ADGroups for $objname. - (get-ADGroups)" -WriteToFile -LogFilePath $LogFileFullpath -Append
                $arrGrp +=@($objsname + " ist Mitglied in folgenden AD-Gruppen:")
                $arrGrp +=""

                foreach($obj in $arrADGroups){
                    $arrGrp += $obj
                }
            }
            catch {
                Write-Log -LogText " --- Error getting ADGroups - (get-ADGroups)" -WriteToFile -LogFilePath $LogFileFullpath -Append
                Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
            }
            if($helper){
                Write-Log -LogText " +++ Writing ADGroups to $($tmpFolder + "\UserInfo_" + $User + "_" + $strDate + ".log")" -WriteToFile -LogFilePath $LogFileFullpath -Append
                #"+++ Active Directory Informationen: "| Out-File $($tmpFolder + "\UserInfo_" + $objsname + "_" + $strDate + ".log") -Append
                $arrGrp | Out-File $($tmpFolder + "\UserInfo_" + $User + "_" + $strDate + ".log") -Append
            }
            else{
                Write-Log -LogText " +++ Writing ADGroups to $($tmpFolder + "\PCInfo_" + $Computerobject.FQDN + "_" + $strDate + ".log")" -WriteToFile -LogFilePath $LogFileFullpath -Append
                #"+++ Active Directory Informationen: "| Out-File $($tmpFolder + "\PCInfo_" + $objsname + "_" + $strDate + ".log") -Append
                $arrGrp | Out-File $($tmpFolder + "\PCInfo_" + $Computerobject.FQDN + "_" + $strDate + ".log") -Append
            }
            

}

function get-ipconfig{
    param(
            [Parameter(Mandatory=$True)][string]$Computer
         )
         Write-Log -LogText " +++ Starting to get Ipconfig of $Computer. - (get-ipconfig)" -WriteToFile -LogFilePath $LogFileFullpath -Append 
         try{ 
            if($global:objcomp.FQDN -eq ((Get-WmiObject Win32_Computersystem).Name + "." + (Get-WmiObject Win32_Computersystem).Domain)){
                Write-Log -LogText " +++ Writing Ipconfig to $($tmpFolder + "\ipconfig_" + $Computer + "_" + $strDate + ".log")" -WriteToFile -LogFilePath $LogFileFullpath -Append 
                ipconfig /all | Out-File $($tmpFolder + "\ipconfig_" + $Computer + "_" + $strDate + ".log") -Append
         }
            else{
                Write-Log -LogText " +++ Writing Ipconfig to $($tmpFolder + "\ipconfig_" + $Computer + "_" + $strDate + ".log")" -WriteToFile -LogFilePath $LogFileFullpath -Append 
                Invoke-Command -computername $Computer {ipconfig /all} | Out-File $($tmpFolder + "\ipconfig_" + $Computer + "_" + $strDate + ".log") -Append
            }
         }
         catch{
            Write-Log -LogText $(" --- Failed to get ipconfig of computer: " + $Computer) -WriteToFile -LogFilePath $LogFileFullpath -Append 
         }

}

function get-whoAmI{
    param(
            [Parameter(Mandatory=$True)][string]$Computer,
            [switch]$localPC
         )

         Write-Log -LogText " +++ Starting to get whoamI infos. - (get-whoAmI)" -WriteToFile -LogFilePath $LogFileFullpath -Append 
         try{ 
            if($localPC.IsPresent){
                Write-Log -LogText " +++ Writing whoamI to $($tmpFolder + "\whoamI_" + $Computer + "_" + $strDate + ".log")" -WriteToFile -LogFilePath $LogFileFullpath -Append 
                whoami.exe /all | Out-File $($tmpFolder + "\whoamI_" + $global:usrLogedOn + "_" + $strDate + ".log") -Append
            }
         }
         catch{
            Write-Log -LogText $(" --- Failed to get whoami infos of User: " + $global:usrLogedOn) -WriteToFile -LogFilePath $LogFileFullpath -Append 
         }
}


function CheckFile{
    param(
          [Parameter(Mandatory=$True)][string]$Computer
         )
    Write-Log -LogText " +++ Starting to get list of files. - (checkFile)" -WriteToFile -LogFilePath $LogFileFullpath -Append

    $path ="\\$Computer\c$\Windows"
    $PLlogs = "$path\logs"
    
    if( $(check-OS -Computer $Computer).OSArchitecture -eq '64-Bit'){        
        $sys= 'SysWoW64'
        Write-Log -LogText " +++ Windows architecture is x64. - (checkFile)" -WriteToFile -LogFilePath $LogFileFullpath -Append 
    }Else{
        $sys='System32'
        Write-Log -LogText " +++ Windows architecture is x86. - (checkFile)" -WriteToFile -LogFilePath $LogFileFullpath -Append
    }
    $ver = Get-WmiObject -NameSpace Root\CCM -Class Sms_Client -ComputerName $Computer | Select-Object -ExpandProperty ClientVersion
    if($(test-path "$path\CCM") -and $ver -gt 5){
        $CCMLogs = "$path\CCM\Logs"
        Write-Log -LogText " +++ SCCM 2012 Client is installed - (checkFile)" -WriteToFile -LogFilePath $LogFileFullpath -Append
    }else{
        $CCMLogs = "$path\$sys\CCM\Logs"
        Write-Log -LogText " +++ SCCM 2007 Client is installed - (checkFile)" -WriteToFile -LogFilePath $LogFileFullpath -Append
    }

    return $FilesToCollect = "$CCMLogs\CcmExec.log“,"$CCMLogs\Cas.log“,"$CCMLogs\execmgr.log“`
    ,"$CCMLogs\ClientLocation.log“,"$CCMLogs\UpdatesDeployment.log“,"$PLlogs\History.log“,"$path\WindowsUpdate.log"`
    ,"$CCMLogs\AppDiscovery.log","$CCMLogs\AppEnforce.log","$PLlogs\DataTransferService.log", "$PLlogs\InventoryAgent.log","$PLlogs\PolicyAgent.log"
}

function CollectFiles{
      param(
          [Parameter(Mandatory=$True)][string]$Computer

      )
      Write-Log -LogText " +++ Starting to copy files. - (collectfiles)" -WriteToFile -LogFilePath $LogFileFullpath -Append 
      try{         

          foreach($File in (CheckFile -Computer $Computer)){
              if(Test-Path -Path $file){
                Write-Log -LogText " +++ File founded: $File copy it. - (collectFile)" -WriteToFile -LogFilePath $LogFileFullpath -Append
                if($noRen.Contains((Split-Path -Leaf $File))){
                    Copy-Item -Path $File -Destination $tmpFolder
                }
                else{
                    $renFile = "SCCM_" + $(Split-Path -Leaf $File) + "_" + $Computer + "_" + $strDate + ".log"
                    Copy-Item -Path $File -Destination $($tmpFolder + "\" + $renFile)
                }            
              }
              else{
                Write-Log -LogText " --- File not found: $file - (collectFiles)" -WriteToFile -LogFilePath $LogFileFullpath -Append
                Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append  
              }          
            }                     
     }
     catch{
            Write-Log -LogText " --- Exception at - (collectFiles)" -WriteToFile -LogFilePath $LogFileFullpath -Append 
            Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
     }
          
}

function get-events{
      param(
          [Parameter(Mandatory=$True)][string]$Computer

      )
      Write-Log -LogText " +++ Getting Eventlogs for the last 24 hours. - (get-events)" -WriteToFile -LogFilePath $LogFileFullpath -Append 
      try{

        $style = @'
        <style>
        body { background-color:#EEEEEE; }
        body,table,td,th { font-family:Tahoma; color:Black; Font-Size:10pt }
        th { font-weight:bold; background-color:#ABAB0A; }
        td { background-color:white; }
        </style>
'@
        Get-EventLog -ComputerName $Computer -LogName System -After $(Get-Date).AddHours(-24) | ConvertTo-Html -Property EventID, MachineName, EntryType,Message,Source,TimeGenerated,UserName  -Head $style | Format-wide  | Out-File $($tmpFolder + "\EventLog_System_" +  $Computer + "_" + $strDate + ".htm") 
        Get-EventLog -ComputerName $Computer -LogName Application -After $(Get-Date).AddHours(-24) | ConvertTo-Html -Property EventID, MachineName, EntryType,Message,Source,TimeGenerated,UserName  -Head $style | Format-wide | Out-File $($tmpFolder + "\EventLog_Application_" +  $Computer + "_" + $strDate + ".htm")
        #Get-EventLog -LogName System -After (Get-Date).AddHours(-24) | ConvertTo-Html -Property EventID, MachineName, EntryType,Message,Source,TimeGenerated,UserName  -Head $style | Format-Table -Wrap | out-file C:\Temp\test2.html
      }
      catch{
        Write-Log -LogText " --- Getting Eventlogs failed. - (get-events)" -WriteToFile -LogFilePath $LogFileFullpath -Append
        Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
        
      }  
}

function Ping-Com{
    [CmdletBinding()]
    Param([string]$Hostname)
        process{
        try {
            write-verbose $Hostname
            $Ali = New-Object -TypeName PSObject -Property @{
                Hostname=$Hostname
                Alive=$false
            }
            $ping  = new-object System.Net.NetworkInformation.Ping
            $Reply = $ping.send($Hostname,500)
            if ($Reply.Status -eq "Success"){
                $Ali.Alive = $true
            }
            return $Ali
            
        }
        catch{
            Write-Log -LogText "Could not find $Hostname!" -WriteToFile -LogFilePath $LogFileFullpath -Append 
            #Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
            return $Ali 
        }
    }
}

function get-dsde{
    Param(
        [string]$comfqdn,
        [switch]$User
    
    )
    #Erstellt ein PSObject als Output. Dies wird von der Funktion get-adgroups als Argument verlangt.
    Write-Log -LogText " +++ Creating DirectoryEntry-Object for adsisearcher. - (get-dsde)" -WriteToFile -LogFilePath $LogFileFullpath -Append

    try{
        if($User.IsPresent){
            $domparts = $global:usrDomain.Split("-")
            $parts = $domparts.count -1
            for ($i=0; $i -le $parts;$i++){
                if($i -eq $parts){
                    $ade+="DC=" + $domparts[$i]
                }
                else{
                    $ade+="DC=" + $domparts[$i] + ","
                }
            }
            
            $ade = [STRING]("LDAP://" + $ade)
            $objUsrDE = New-Object System.DirectoryServices.DirectoryEntry($ade)
            $pso = New-Object PSObject -ArgumentList @{
                Username=$global:usrLogedOn
                DirectoryEntry=$objUsrDE
            }

            return $pso

        }else{
            if($comfqdn -match "(\w\.\w)"){                        
                $comparts = $comfqdn.split(".")
                $comname = $comparts[0]
                $comdomain = $comfqdn.substring($comname.length + 1)
                $parts = $comparts.count -1
                for ($i=1; $i -le $parts;$i++){
                    if($i -eq $parts){
                        $ade+="DC=" + $comparts[$i]
                    }
                    else{
                        $ade+="DC=" + $comparts[$i] + ","
                    }
                }
                 $ade = [STRING]("LDAP://" + $ade)
                 $objDE = New-Object System.DirectoryServices.DirectoryEntry($ade)
                 $pso = New-Object PSObject -ArgumentList @{
                            Computername=$comname
                            Computerdomain=$comdomain
                            FQDN=$comfqdn
                            DirectoryEntry=$objDE
                         }
      
                 return $pso    
             }
             else{
                  Write-Warning "The inputformat for the destination computer does not match the criteria for a fqdn! e.g.: computername.be.ch"
                  Write-Log -LogText " +++ Error creating DirectoryEntry-Object for adsisearcher. - (get-dsde)" -WriteToFile -LogFilePath $LogFileFullpath -Append
                  Write-Log -LogText "The inputformat for the destination computer does not match the criteria for a fqdn! e.g.: computername.be.ch" -WriteToFile -LogFilePath $LogFileFullpath -Append
             }
        }
    }
    catch{
        Write-Log -LogText " +++ Error creating DirectoryEntry-Object for adsisearcher. - (get-dsde)" -WriteToFile -LogFilePath $LogFileFullpath -Append
        Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append

    }
}

function get-BasicInfo{
      param(
          [Parameter(Mandatory=$True)][string]$Computer

      )
      Write-Log -LogText " +++ Getting Client data from registry. - (get-BasicInfo)" -WriteToFile -LogFilePath $LogFileFullpath -Append
      try{
        $keypath = 'HKLM:SOFTWARE\PHBern\SCCM' # Path changed bai 22.03
        if($Script:runremote){
            $res=invoke-Command -ScriptBlock {param($path);Get-ItemProperty -Path $Path} -ArgumentList $keypath -ComputerName $Computer
        }else{
            $res=Get-ItemProperty -Path $keypath
        }
        return $res
        }
    catch{
        Write-Log -LogText " --- Getting Client data. - (get-BasicInfo)" -WriteToFile -LogFilePath $LogFileFullpath -Append
        Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
    }

}
# -----------
#Main Function to call all function for detailed informationen
function Start-detail{
    If (Test-Path $($tmpFolder + "\PCInfo_" + $Computer + "_" + $strDate + ".log")) {Remove-Item $($tmpFolder + "\PCInfo_" + $Computer + "_" + $strDate + ".log")}
    If (Test-Path $($tmpFolder + "\UserInfo_" + $Computer + "_" + $strDate + ".log")) {Remove-Item $($tmpFolder + "\UserInfo_" + $Computer + "_" + $strDate + ".log")}
    "+++ Starting detailed information locally" | Out-File $($tmpFolder + "\PCInfo_" + $Computer + "_" + $strDate + ".log") -Append
     $profilepath = get-OSVer     
     $i=0
     $sum=11

     if ($chkGPO.Checked -eq $true){
        $amount=12
        update-pgb -i (++$i) -amount $sum -stat "Getting GPResult..."
        get-GPresult
         
     }

     update-pgb -i (++$i) -amount $sum -stat "Getting basic information..."     
     get-basics -Computer $Computer -localPC -BasicsToFile

     update-pgb -i (++$i) -amount $sum -stat "Getting profile information..."
      "Size of " + $profilepath + " is: {0:0.00}" -f $(get-profileSize -Computer $Computer)`
     + " MB"| Out-File $($tmpFolder + "\UserInfo_" + $global:usrLogedOn + "_" + $strDate + ".log") -Append

     update-pgb -i (++$i) -amount $sum -stat "Getting events..."
     get-events -Computer $Computer

     update-pgb -i (++$i) -amount $sum -stat "Getting running processes..."
     get-runningProcesses -Computer $Computer

     update-pgb -i (++$i) -amount $sum -stat "Getting IP configuration..."
     get-ipconfig -Computer $Computer
     
     update-pgb -i (++$i) -amount $sum -stat "Getting computers AD membership..."
     get-ADGroups -Computerobject $global:objcomp 
     
     update-pgb -i (++$i) -amount $sum -stat "Getting users AD membership..."
     get-ADGroups -Userobject $global:objusr -UserInfo

     update-pgb -i (++$i) -amount $sum -stat "Getting user information..."
     Get-UserInfos -Computer $Computer -LoggedOnUser $global:usrLogedOn

     update-pgb -i (++$i) -amount $sum -stat "Getting WhoAmI information..."
     get-whoAmI -Computer $Computer -localPC

     update-pgb -i (++$i) -amount $sum -stat "Getting files to zip..."
     CollectFiles -Computer $Computer

     update-pgb -i (++$i) -amount $sum -stat "Zipping files..."
     New-ZipFile $zipdatei $tmpFolder

}
function update-pgb{
    param(
        [int]$i,
        [int]$amount,
        [string]$stat="Gathering Information..."
    )
    
    [int]$pct = ($i/$amount)*100
    $progressbar1.Value = $pct

    $objForm.Refresh()
    if($i -eq 1){
        $progressbar1.Maximum = $amount * 10
        $progressBar1.Visible = $true
        $objLabel.Visible = $true
        $objForm.Refresh()
    }
    elseif($i -eq $amount){
        $progressBar1.Visible = $false
        $progressbar1.Value = 0
        $objLabel.Visible = $false
        $objForm.Refresh()

    }
    else{
        if($stat){
            $objLabel.Text = $stat
            $objForm.Refresh()
        }
    }
    
}
function update-pgbShell{
    param(
        [int]$i,
        [int]$amount,
        [String]$stat="Tool Actions in Progress..."
    )

    Write-Progress -activity "Gathering Supporttool Information" -status $stat -PercentComplete (($i / $amount)  * 100)


}

#Wird benötigt, damit das Consolen Fenstern nur bei "Remote" geöffnet wird
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Show-Console{
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 5)
}

function Hide-Console{
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)
}
function get-OSVer{
    Write-Log -LogText " +++ Getting OS Version Userprofilepath... - (get-OSVer)" -WriteToFile -LogFilePath $LogFileFullpath -Append
    $OSVer = [System.Environment]::OSVersion.Version.Major
    if($OSVer -lt 10){ 
        $profpath = "\\" + $Computer + "\C$\Users\" + $global:usrLogedOn + "\AppData\Roaming"
    }else{
        $profpath = "\\" + $Computer + "\C$\Users\" + $global:usrLogedOn + "\AppData\Local"
    }
    $profpath
}
#----------------------------------------------------------------------------------------------------|
#endregion
# FUNCTIONS - END

#----------------------------------------------------------------------------------------------------|
#----------------------------------------------------------------------------------------------------|

#region GLOBAL VARIABLES - START
#----------------------------------------------------------------------------------------------------|
$global:arrAppPaths=@{"snp"="$env:windir\system32\snippingtool.exe"}
$global:arrAppPaths+=@{"psr"="$env:windir\system32\psr.exe"}

#get-checkbox erstellt die Variable $Script:runremote $script:strFQDN
Hide-Console | out-null
get-checkbox

if($Script:runremote -eq $true){
    $comp = $Script:strFQDN
}
elseif($Script:runremote -eq $false){
    $comp = $(Get-WmiObject Win32_Computersystem).Name + "." + $(Get-WmiObject Win32_Computersystem).Domain

}

$tmpFolder = "C:\temp\SDKTool\$comp"
$zipPath = "C:\temp\SDKTool\$comp"
$strDate = Get-Date -Format "yyMMdd"
$zipdatei= $zipPath + "_" + $Env:USERNAME + "_" + $strDate + ".zip"
$Path_Log = "$tmpFolder\Log"
$LogFileFullpath = $( Join-Path -Path $Path_Log -Childpath $("SDKT_" + $strDate + ".log"))


#Files welche eingesammelt werden sollen
$FilesToCollect = "CcmExec.log“,"Cas.log“,"execmgr.log“,"ClientLocation.log“,"UpdatesDeployment.log“,"History.log“,"WindowsUpdate.log","AppDiscovery.log","AppEnforce.log","DataTransferService.log","InventoryAgent.log","PolicyAgent.log"

#Files von FilesToCollect, welche nicht in SCCM_... umbenannt werden sollen
$noRen="History.log“,"WindowsUpdate.log"

$ErrorActionPreference = 'Stop'
$crlf = [string][char[]](13,10)
#----------------------------------------------------------------------------------------------------|
#endregion
# GLOBAL VARIABLES - END

#region MAIN - START
#----------------------------------------------------------------------------------------------------|
try{
    Create-Folder $($Path_Log)
    Write-Log -LogText "$(get-date -Format yyyy-MM-dd) - Starting ServiceDesk Support Tool !" -WriteToFile -LogFilePath $LogFileFullpath -Append

    if($Script:runremote -eq $false){
        $global:objcomp = get-dsde $comp
        $computer = $global:objcomp.FQDN
        [string]$strUsr = $(Get-WmiObject -computername $computer Win32_Computersystem).Username
        
        if (!([string]::IsNullOrEmpty($strUsr))){
            [string]$global:usrDomain = $($strUsr.Split("\")[0])
            [string]$global:usrLogedOn = $($($(Get-WmiObject -computername $computer Win32_Computersystem).Username).Split("\"))[1]
        }
        else{
            [string]$global:usrDomain = $env:USERDOMAIN
            [string]$global:usrLogedOn = $env:USERNAME
        }
        $global:objusr = get-dsde -user

        Show-Gui -Gui
            
        
    }
    elseif($Script:runremote -eq $true){
        Show-Console | out-null
        $global:objcomp = get-dsde $comp
        $computer = $global:objcomp.FQDN
        $i=0
                
        if( $(Ping-Com $computer).Alive){
                    
            [string]$strUsr = $(Get-WmiObject -computername $computer Win32_Computersystem).Username

            if (!([string]::IsNullOrEmpty($strUsr))){
                $sum=10
                [string]$global:usrDomain = $($strUsr.Split("\")[0])
                [string]$global:usrLogedOn = $($($(Get-WmiObject -computername $computer Win32_Computersystem).Username).Split("\"))[1]
                $global:objusr = get-dsde -user
                $profilepath = get-OSVer

                update-pgbShell -i (++$i) -amount $sum -stat "Getting profile information..."
                "Size of " + $profilepath + " is: {0:0.00}" -f $(get-profileSize -Computer $Computer)`
                + " MB"| Out-File $($tmpFolder + "\UserInfo_" + $global:usrLogedOn + "_" + $strDate + ".log") -Append

                update-pgbShell -i (++$i) -amount $sum -stat "Getting AD membership of $global:usrLogedOn"
                get-ADGroups -Userobject $global:objusr -UserInfo
                    
                update-pgbShell -i (++$i) -amount $sum -stat "Getting user information..."
                Get-UserInfos -Computer $Computer -LoggedOnUser $global:usrLogedOn

                }
                else{
                    $sum=7
                    Write-Warning $("There is no active user on " + $Computer + "...")
                    Write-Log -LogText $(" --- Getting logedon user: On " + $Computer + " is currently no active console user loged on. Userdata will be skipped!") -WriteToFile -LogFilePath $LogFileFullpath -Append
                }
                                            
                update-pgbShell -i (++$i) -amount $sum -stat "Getting basic information on $comp..."
                get-basics -Computer $Computer -BasicsToFile

                update-pgbShell -i (++$i) -amount $sum -stat "Getting running processes on $comp..."        
                get-runningProcesses -Computer $Computer
                    
                update-pgbShell -i (++$i) -amount $sum -stat "Getting events on $comp..."
                get-events -Computer $Computer

                update-pgbShell -i (++$i) -amount $sum -stat "Getting IP configuration on $comp..."
                get-ipconfig -Computer $Computer

                update-pgbShell -i (++$i) -amount $sum -stat "Getting AD membership of $comp..."
                get-ADGroups -Computerobject $global:objcomp

                update-pgbShell -i (++$i) -amount $sum -stat "Getting files to zip..." 
                CollectFiles -Computer $Computer
                    
                update-pgbShell -i (++$i) -amount $sum -stat "Zipping files to $env:userprofile\Desktop"
                New-ZipFile $zipdatei $tmpFolder
                
        }
        else{
            Write-Warning "The destination computer could not be found. The script is about to finish..."
            Start-Sleep 5                      
        } 
    }
}catch{
    Write-Log -LogText " --- ServiceDesk Support Tool. - (Main)" -WriteToFile -LogFilePath $LogFileFullpath -Append
    Write-Log -LogText $_.Exception -WriteToFile -LogFilePath $LogFileFullpath -Append 
}
  

#----------------------------------------------------------------------------------------------------|
#endregion
# MAIN - END