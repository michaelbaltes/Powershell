Param (
    [Parameter(Mandatory = $true)]
    [string]$ActionParam = "Install"
)

[xml]$XAMLMain = @'
<Window Name="frmRelease2"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:SibapReleaseService"
        Title="Sibap Release Service" Height="384" Width="587.979" ResizeMode="NoResize">

    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="79*"/>
            <ColumnDefinition Width="562*"/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="50"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Rectangle Grid.Row="0" Fill="#0070bc" HorizontalAlignment="Left" Height="50" Margin="0,0,-0.333,0" VerticalAlignment="Top" Width="583" Grid.ColumnSpan="2"/>
        <Image Name="imgLogo" Grid.Row="0" HorizontalAlignment="Left" Height="33" Margin="21,10,0,0" VerticalAlignment="Top" Width="175" Source="stzh-center-logo.png" Grid.ColumnSpan="2"/>
        <TabControl Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Top" FontSize="12" FontFamily="Arial" Grid.ColumnSpan="2" Height="305" Margin="0,0,0,-0.333">
            <TabItem Name="tabRelease" Header="Release" Background="#FFFFFF">
                <Grid Background="#FFFFFF" Width="580" Height="283">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="6*"/>
                        <ColumnDefinition Width="61*"/>
                        <ColumnDefinition Width="67*"/>
                        <ColumnDefinition Width="419*"/>
                    </Grid.ColumnDefinitions>
                    <Button Name="cmdRun" Content="Ausführen" HorizontalAlignment="Left" Margin="334.333,241,0,0" VerticalAlignment="Top" Width="75" Background="White" RenderTransformOrigin="0.998,1.591" Grid.Column="3"/>
                    <ListBox Name="listApps" HorizontalAlignment="Left" Height="164" Margin="72.333,65,0,0" VerticalAlignment="Top" Width="337" Grid.Column="3"/>
                    <Label Content="Applikationen:" HorizontalAlignment="Left" Margin="3.584,65,0,0" VerticalAlignment="Top" Grid.ColumnSpan="2" Grid.Column="1"/>
                    <TextBlock Name="txtNotification" Grid.Column="1" HorizontalAlignment="Left" Margin="10.333,10,0,0" TextWrapping="Wrap" Text="TextBlock" VerticalAlignment="Top" Grid.ColumnSpan="3" Height="50" Width="533"/>
                </Grid>
            </TabItem>
            <TabItem Name="tabSettings" Header="Einstellungen" FontSize="12" FontFamily="Arial">
                <Grid Background="#FFFFFF">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="10"/>
                        <ColumnDefinition Width="18.559"/>
                        <ColumnDefinition Width="81.441"/>
                        <ColumnDefinition Width="515"/>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="10"/>
                        <RowDefinition Height="50"/>
                        <RowDefinition Height="50"/>
                        <RowDefinition Height="50"/>
                        <RowDefinition Height="50"/>
                        <RowDefinition Height="50"/>
                    </Grid.RowDefinitions>
                    <Label Name="lblDisclaimer" Content="Definieren Sie ihre Arbeitszeit.&#xD;&#xA;Ausserhalb dieser Zeit kann Ihr PC ohne Voranmeldung neu gestartet werden." Grid.Row="1" Grid.Column="1" Grid.ColumnSpan="3" FontWeight="Bold" Margin="0,10,0.667,40" Grid.RowSpan="2"/>
                    <Label Name="lblWorktimeStart" Content="Arbeitszeit Start:" HorizontalAlignment="Left" VerticalAlignment="Center" Width="96" Height="26" Grid.Column="1" Grid.Row="2" Grid.ColumnSpan="2" Margin="0,12"/>
                    <Label Name="lblWorktimeEnd" Content="Arbeitszeit Ende:" HorizontalAlignment="Left"  VerticalAlignment="Center" Width="100" Height="26" Grid.Column="1" Grid.Row="3" Grid.ColumnSpan="2" Margin="0,12"/>
                    <ComboBox Name="comboStartTime" HorizontalAlignment="Left" VerticalAlignment="Center" Width="120" BorderBrush="White" Grid.Column="3"  Grid.Row="2" Margin="20,17,0,12" Height="21">
                        <ComboBox.Background>
                            <LinearGradientBrush EndPoint="0,1" StartPoint="0,0">
                                <GradientStop Color="#FFF0F0F0" Offset="0"/>
                                <GradientStop Color="White" Offset="1"/>
                            </LinearGradientBrush>
                        </ComboBox.Background>
                        <ComboBoxItem Content="00:00"/>
                        <ComboBoxItem Content="01:00"/>
                        <ComboBoxItem Content="02:00"/>
                        <ComboBoxItem Content="03:00"/>
                        <ComboBoxItem Content="04:00"/>
                        <ComboBoxItem Content="05:00"/>
                        <ComboBoxItem Content="06:00"/>
                        <ComboBoxItem Content="07:00"/>
                        <ComboBoxItem Content="08:00"/>
                        <ComboBoxItem Content="09:00"/>
                        <ComboBoxItem Content="10:00"/>
                        <ComboBoxItem Content="11:00"/>
                        <ComboBoxItem Content="12:00"/>
                        <ComboBoxItem Content="13:00"/>
                        <ComboBoxItem Content="14:00"/>
                        <ComboBoxItem Content="15:00"/>
                        <ComboBoxItem Content="16:00"/>
                        <ComboBoxItem Content="17:00"/>
                        <ComboBoxItem Content="18:00"/>
                        <ComboBoxItem Content="19:00"/>
                        <ComboBoxItem Content="20:00"/>
                        <ComboBoxItem Content="21:00"/>
                        <ComboBoxItem Content="22:00"/>
                        <ComboBoxItem Content="23:00"/>
                    </ComboBox>
                    <ComboBox Name="comboEndTime" HorizontalAlignment="Left" VerticalAlignment="Center" Width="120" BorderBrush="White" Grid.Column="3"  Grid.Row="3" Margin="20,17,0,12" Height="21">
                        <ComboBox.Background>
                            <LinearGradientBrush EndPoint="0,1" StartPoint="0,0">
                                <GradientStop Color="#FFF0F0F0" Offset="0"/>
                                <GradientStop Color="White" Offset="1"/>
                            </LinearGradientBrush>
                        </ComboBox.Background>
                        <ComboBoxItem Content="00:00"/>
                        <ComboBoxItem Content="01:00"/>
                        <ComboBoxItem Content="02:00"/>
                        <ComboBoxItem Content="03:00"/>
                        <ComboBoxItem Content="04:00"/>
                        <ComboBoxItem Content="05:00"/>
                        <ComboBoxItem Content="06:00"/>
                        <ComboBoxItem Content="07:00"/>
                        <ComboBoxItem Content="08:00"/>
                        <ComboBoxItem Content="09:00"/>
                        <ComboBoxItem Content="10:00"/>
                        <ComboBoxItem Content="11:00"/>
                        <ComboBoxItem Content="12:00"/>
                        <ComboBoxItem Content="13:00"/>
                        <ComboBoxItem Content="14:00"/>
                        <ComboBoxItem Content="15:00"/>
                        <ComboBoxItem Content="16:00"/>
                        <ComboBoxItem Content="17:00"/>
                        <ComboBoxItem Content="18:00"/>
                        <ComboBoxItem Content="19:00"/>
                        <ComboBoxItem Content="20:00"/>
                        <ComboBoxItem Content="21:00"/>
                        <ComboBoxItem Content="22:00"/>
                        <ComboBoxItem Content="23:00"/>
                    </ComboBox>
                    <CheckBox Name="chk_Monday" Content="Montag" HorizontalAlignment="Left" VerticalAlignment="Center" Height="20" Width="66" IsChecked="True" Grid.Column="1" Grid.Row="4" Grid.ColumnSpan="2" Margin="0,16,0,14"/>
                    <Button Name="cmdSave" Content="Speichern" HorizontalAlignment="Left" VerticalAlignment="Center" Width="75" Background="White" Grid.Column="1"  Grid.Row="5" Margin="0,10,0,21" Height="19" Grid.ColumnSpan="2"/>
                    <CheckBox Name="chk_Saturday" Content="Samstag" HorizontalAlignment="Left" VerticalAlignment="Center" Height="20" Width="71" IsChecked="True" Grid.Column="3" Grid.Row="4" Margin="270,16,0,14"/>
                    <CheckBox Name="chk_Tuesday" Content="Dienstag" HorizontalAlignment="Left" VerticalAlignment="Center" Height="20" Width="75" IsChecked="True" Grid.Column="2" Grid.Row="4" Grid.ColumnSpan="2" Margin="47.333,16,0,14"/>
                    <CheckBox Name="chk_Wednesday" Content="Mittwoch" HorizontalAlignment="Left" VerticalAlignment="Center" Height="20" Width="75" IsChecked="True" Grid.Column="3" Grid.Row="4" Margin="41,16,0,14"/>
                    <CheckBox Name="chk_Thursday" Content="Donnerstag" HorizontalAlignment="Left" VerticalAlignment="Center" Height="20" Width="89" IsChecked="True" Grid.Column="3" Grid.Row="4" Margin="116,16,0,14"/>
                    <CheckBox Name="chk_Friday" Content="Freitag" HorizontalAlignment="Left" VerticalAlignment="Center" Height="20" Width="75" IsChecked="True" Grid.Column="3" Grid.Row="4" Margin="206,16,0,14"/>
                    <CheckBox Name="chk_Sunday" Content="Sonntag" HorizontalAlignment="Left" VerticalAlignment="Center" Height="20" Width="71" IsChecked="True" Grid.Column="3" Grid.Row="4" Margin="346,16,0,14"/>
                    <Label Name="lblSaved" Content="Label" Grid.Column="2" HorizontalAlignment="Left" Margin="72.333,10.667,0,0" Grid.Row="5" VerticalAlignment="Top" RenderTransformOrigin="-0.381,0.25" Grid.ColumnSpan="2"/>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
</Window>

'@


#region Initialisierung
$trigger = "{00000000-0000-0000-0000-000000000021}"
$machine = $env:COMPUTERNAME
$MaintenanceKeysCache = "HKLM:\SOFTWARE\Maintenance\Caching"
$MaintenanceKeysPackages = "HKLM:\SOFTWARE\Maintenance\Packages"
$EnvironmentKeys = "HKLM:\SOFTWARE\Maintenance\Environment"
$ReleaseXML = "C:\Windows\Maintenance\SWDeployment\Release.xml"
$ReleaseMaintenance = "HKLM:\SOFTWARE\Maintenance\Release"
$MaintenanceEnv = "HKLM:\SOFTWARE\Maintenance\Environment"
$MaintenanceEnvWow6432 = "HKLM:\SOFTWARE\WOW6432Node\Maintenance\Environment"
$ReleaseMaintenanceTSStatus = "HKLM:\SOFTWARE\Maintenance\Release\TSStatus"
$Eventlog = "OIZ Sibap Release"
$ProzessLog = "C:\Windows\Maintenance\LogFiles\SibapReleaseService.log"
$SCCMAutomation = "C:\Windows\Maintenance\SWDeployment\smsclictr.automation.dll"
$sibapbuild = Get-ItemPropertyValue -Path $EnvironmentKeys -Name "sibapbuild"
$Global:ActionTask = $ActionParam

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore



$reader = (New-Object System.Xml.XmlNodeReader $XAMLMain)
$windowMain = [Windows.Markup.XamlReader]::Load( $reader )

$XAMLMain.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name "WPF$($_.Name)" -Value $windowMain.FindName($_.Name) }

$WPFimgLogo.Source = $PSScriptRoot + "\stzh-center-logo.png"
#$imgLogo.Source = "$($scriptPt)stzh-center-logo.png"

#endregion


function ReadXML {
    param (
        $xmlpath
    )
    
    [xml]$XMLContent = Get-Content($xmlpath)
    return $XMLContent
}

function SaveXML {
    param (
        $XMLContent,
        $xmlpath
    )
    $XMLContent.Save($xmlpath)

    return
}

function CheckKeys {
    param (
        $ReleaseXML,
        $MaintenanceKey
    )

    $KeyExists = $true

    $arrPKGCache = (Get-ChildItem -Path $MaintenanceKey).PSChildName

    $XMLContent = ReadXML -xmlpath $ReleaseXML
    $packages = $XMLContent.ChildNodes.Packages
    $Tasksequences = $XMLContent.ChildNodes.Tasksequences

    if (($packages.pkg.Count -gt 0) -or ($Tasksequences.ts.Count -gt 0)) {
        if ($packages.pkg.Count -gt 0) {                
            foreach ($pkg in $packages.pkg) {
                if (!($arrPKGCache.Contains(($pkg -replace "_", " ")))) {
                    $KeyExists = $false
                }
                else {                    
                    #$node = $XMLContent.SelectSingleNode("Release/Packages/pkg") | where {$_.InnerText -eq $pkg}
                    $node = $XMLContent.SelectSingleNode("Release/Packages/pkg[.='$pkg']")
                    $result = $node.ParentNode.RemoveChild($node)
                }
            }
        }
        if ($Tasksequences.ts.Count -gt 0) {
            $i = 1
            foreach ($ts in $Tasksequences.ts) {
                if (!($arrPKGCache.Contains(($ts -replace "_", " ")))) {
                    $KeyExists = $false
                }
                else {
                    $node = $XMLContent.SelectSingleNode("Release/Tasksequences/ts[.='$ts']")
                    $result = $node.ParentNode.RemoveChild($node)
                     
                    $result = Remove-ItemProperty -Path "HKLM:\SOFTWARE\Maintenance\Release\TSStatus" -Name (($ts + "-Inst") -replace "_", " ") -Force -ErrorAction SilentlyContinue | Out-Null
                }
            }
        }
        $result = $XMLContent.save($ReleaseXML)
    }
    If (!($KeyExists)) {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Maintenance keys checked, applications available to install"
    }
    else {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Maintenance keys checked, all applications installed"
    }

    Return $KeyExists
}

function CheckTS {
    param (
        $ReleaseXML,
        $MaintenanceKey,
        $SibapReleaseTS
    )
    
    $MaintenanceTasksequence = "HKLM:\SOFTWARE\Maintenance\Release\TSStatus"

    $KeyExists = $true

    $arrPKGCache = (Get-ChildItem -Path $MaintenanceKey).PSChildName

    $XMLContent = ReadXML -xmlpath $ReleaseXML

    $Tasksequences = $XMLContent.ChildNodes.Tasksequences
        
    if ($Tasksequences.ts.Count -gt 0) {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Available tasksequences found"
        foreach ($ts in $Tasksequences.ts) {
            if (!($arrPKGCache.Contains(($ts -replace "_", " ")))) {
                $KeyExists = $false
                
                try {
                    $TSDeployStatus = Get-ItemPropertyValue -Path $MaintenanceTasksequence -Name $ts
                    if ($TSDeployStatus -eq "Deployed") {
                        $TSDeploy = $true
                    }
                    else { 
                        $TSDeploy = $false
                    }
                }
                catch {
                    $TSDeploy = $false
                }

                if (!($TSDeploy)) {
                    DeployTS -TSName $ts
                }
            }
        }
    }

    $Packages = $XMLContent.ChildNodes.Packages

    if ($packages.pkg.Count -gt 0) {
    

    }

    return $KeyExists
}

function DeployTS {
    param (
        $TSName
    )

    $MaintenanceTasksequence = "HKLM:\SOFTWARE\Maintenance\Release\TSStatus"
    $uri = "http://ServerXXX:88/WebSrvSccmMgmt.asmx"
    $return = @()

    $proxy = New-WebServiceProxy $uri
    $CollectionName = ($TSName -replace "_", " ") + "-Inst"

    $CollectionID = $proxy.GetCollectionIdByName($CollectionName)
    $return = $proxy.AddToCollectionByName($env:COMPUTERNAME, $CollectionID)

    if ($true -eq $return) {
        New-ItemProperty -Path $MaintenanceTasksequence -Name (($TSName -replace "_", " ") + "-Inst") -Value "Deployed" -Force | Out-Null
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Deployment created for tasksequence $TSName"
    }
    else {
        New-ItemProperty -Path $MaintenanceTasksequence -Name (($TSName -replace "_", " ") + "-Inst") -Value "Open" -Force | Out-Null
    }

}

function RunTS {

    param (
        $SibapReleaseTS,
        $SACTS
    )
    
    Import-Module $SCCMAutomation
    $RemoteSMSClient = New-Object -TypeName smsclictr.automation.SMSClient($env:COMPUTERNAME)

    $arrTS = @()

    
    if (!($SACTS)) {
        $Path = "HKLM:\SOFTWARE\Maintenance\Release\TSStatus"
        (Get-Item -Path $Path).Property | ForEach-Object {

            If ((Get-ItemPropertyValue -Path $Path -Name $_) -eq "Deployed") {     
                $arrTS += $_
            }
        }
    }
    else {
        $arrTS += $SACTS
    }
    
    $SCCMService = Get-Service -Name CcmExec -ErrorAction SilentlyContinue

    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Check if sccm client is running."
    while ($SCCMService.Status -ne "Running") {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "SCCM client agent not running."
        Start-Sleep 20
        $SCCMService = Get-Service -Name CcmExec -ErrorAction SilentlyContinue
    }

    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Check if all tasksequences are ready for installation."
    
    do {
        $TSAvailable = $true
        Invoke-WmiMethod -ComputerName $machine -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger | Out-Null
        Start-Sleep -Seconds 30

        $arrTS | ForEach-Object {

            $TSName = $_

            $TS = $RemoteSMSClient.SoftwareDistribution.Advertisements | Where-Object { $_.PKG_Name -like "$TSName" }
            if (!($TS)) {
                $TSAvailable = $false
            }
        }
    }while ($false -eq $TSAvailable)

    Invoke-WmiMethod -ComputerName $machine -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger | Out-Null
    Start-Sleep -Seconds 30
    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "All tasksequences are ready for installation"

    foreach ($ts in $arrTS) {
        if ($arrTS.Count -gt 1) {
            if ($ts -ne ($SibapReleaseTS + "-Inst")) {
                
                $TStoRun = $RemoteSMSClient.SoftwareDistribution.Advertisements | Where-Object { $_.PKG_Name -like "$ts" }
                if ($TStoRun) {                 
                    $install = $RemoteSMSClient.SoftwareDistribution.RerunAdv($TStoRun.ADV_AdvertisementID, $TStoRun.PKG_PackageID, $TStoRun.PRG_ProgramID)
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Running tasksequence $($TStoRun.PackageName)" 
                    break                                   
                }
            }
        }
        else {
            $TStoRun = $RemoteSMSClient.SoftwareDistribution.Advertisements | Where-Object { $_.PKG_Name -like "$ts" }
            if ($TStoRun) {                 
                $install = $RemoteSMSClient.SoftwareDistribution.RerunAdv($TStoRun.ADV_AdvertisementID, $TStoRun.PKG_PackageID, $TStoRun.PRG_ProgramID)
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Running tasksequence $($TStoRun.PackageName)" 
                break                                   
            }
        }

    } 

    return
}

function WriteInventar {
    
    #Read MaintenanceKeys an write them to an XML
    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Write inventar" 
    $XMLFilePath = "C:\Windows\Maintenance\SWDeployment\Inventar.xml"
    $MaintenanceKeysPackages = "HKLM:\SOFTWARE\Maintenance\Packages"
    $EnvironmentKeys = "HKLM:\SOFTWARE\Maintenance\Environment"
    $arrPKGCache = (Get-ChildItem -Path $MaintenanceKeysPackages).PSChildName
    $SibapBuildLevel = Get-ItemPropertyValue -Path $EnvironmentKeys -Name "sibapbuildlevel"
    $sibapbuild = Get-ItemPropertyValue -Path $EnvironmentKeys -Name "sibapbuild"
    $area = Get-ItemPropertyValue -Path $EnvironmentKeys -Name "area"
    $BIOSDate = Get-Date -Date (Get-CimInstance win32_bios).ReleaseDate -Format "yyyy-MM-dd"
    $BIOSVersion = (Get-CimInstance win32_bios).SMBIOSBIOSVersion
    $HardwareType = (Get-CimInstance win32_ComputerSystem).Model

    # Set The Formatting
    $xmlsettings = New-Object System.Xml.XmlWriterSettings
    $xmlsettings.Indent = $true
    $xmlsettings.IndentChars = "    "

    # Set the File Name Create The Document
    $XmlWriter = [System.XML.XmlWriter]::Create($XMLFilePath, $xmlsettings)

    # Write the XML Decleration and set the XSL
    $xmlWriter.WriteStartDocument()
    $xmlWriter.WriteProcessingInstruction("xml-stylesheet", "type='text/xsl' href='style.xsl'")

    $xmlWriter.WriteStartElement("Inventar")
    $xmlWriter.WriteStartElement("Release")
    $xmlWriter.WriteElementString("ComputerName", $env:COMPUTERNAME)
    $xmlWriter.WriteElementString("SibapBuildLevel", $SibapBuildLevel)
    $xmlWriter.WriteElementString("SibapBuild", $sibapbuild)
    $xmlWriter.WriteElementString("Area", $area)
    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteStartElement("Hardware")
    $xmlWriter.WriteElementString("BIOSVersion", $BIOSVersion)
    $xmlWriter.WriteElementString("BIOSReleaseDate", $BIOSDate)
    $xmlWriter.WriteElementString("Hardwaretyp", $HardwareType)
    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteStartElement("Software")
    $xmlWriter.WriteStartElement("Packages")

    $arrPKGCache | ForEach-Object {
        $xmlWriter.WriteElementString("Package", ($_ -replace " ", "_"))
    }
    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteEndElement()

    # End, Finalize and close the XML Document
    $xmlWriter.WriteEndDocument()
    $xmlWriter.Flush()
    $xmlWriter.Close()
    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Finished inventar" 
}

function WriteLog {
    param (
        $Log,
        $Message,
        $Type,
        $Source,
        $ID
    )

    if (!(Test-Path $ProzessLog)) {
        Set-Content -Path $ProzessLog -Value ((Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " - Info: Log created.")
    }
    
    Write-EventLog -LogName $Log -Source $Source -EntryType $Type -EventId $ID -Message $Message
    $Message = (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " - " + $Type + ": " + $Message
    Add-Content -Path $ProzessLog -Value $Message
}

function CheckClient {

    if (($env:COMPUTERNAME).StartsWith("XXXV")) {
        $Clienttype = "VDIPersonal"
    }
    elseif (($env:COMPUTERNAME).StartsWith("XXXL")) {
        $Clienttype = "Notebook"
    }
    elseif (($env:COMPUTERNAME).StartsWith("XXXE")) {
        $Clienttype = "Desktop"  
    } 

    return $Clienttype
}

function RemoveFromColl {

    Param(
        [string]$CollectionName
    )

    #Script RemoveClientFromCollection_v2.ps1 aus Tasksequence - Autor: Falko
    try {
        [String]$StagenieServername = (Get-ItemProperty -path 'HKLM:\SOFTWARE\Maintenance\Environment' -name "WebServiceServer_Mgmt1" -ErrorAction SilentlyContinue).WebServiceServer_Mgmt1
        if ([string]::IsNullOrEmpty($StagenieServername)) {
            WriteLog -Log $Eventlog -Source $Eventlog -Type "Error" -ID 1 -Message "Can't find Regkey HKLM:\SOFTWARE\Maintenance\Environment\WebServiceServer_Mgmt1"
            return
        }
        $Serverllist = $StagenieServername.Split(';')
        foreach ($ServerURL in $Serverllist) {        
            if ($ServerURL) {
                try {
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Remove from Collection '$CollectionName' computer '$env:computername' by StagenieServer '$StagenieServername'"                 
                    $WebService = New-WebServiceProxy -uri ($ServerURL) -UseDefaultCredential -Class int -Namespace OrderingWebService 
                    [int]$result = 0
                    $result = $WebService.OrderingDB_AddOrder_RemoveSccmComputerFromCollection($env:computername, $CollectionName, "PU3")
                    if ($result) {
                        $result
                        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Order wurde erstellt. -OrderID:' $result"  
                        break
                    }
                }
                catch {
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Error" -ID 1 -Message "Order couldn't be create: $($_.Exception.Message)"  
                }
            }            
        }
    }
    catch {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Error" -ID 1 -Message "SCCMRemovefromCollection: $($_.Exception.Message)"
    }

}

Function GetBusinessHours {
    
    $cmClientUserSettings = [WmiClass]"\\.\ROOT\ccm\ClientSDK:CCM_ClientUXSettings"
    $businessHours = $cmClientUserSettings.GetBusinessHours()
    $DaysBinary = [System.Convert]::ToString($businessHours.WorkingDays, 2).PadLeft(8, '0')

    $WorkingDaysInfo = @{
        StartTime = $businessHours.StartTime;
        EndTime   = $businessHours.EndTime;
        Sunday    = $DaysBinary.Substring(7, 1);
        Monday    = $DaysBinary.Substring(6, 1);
        Tuesday   = $DaysBinary.Substring(5, 1);
        Wednesday = $DaysBinary.Substring(4, 1);
        Thursday  = $DaysBinary.Substring(3, 1);
        Friday    = $DaysBinary.Substring(2, 1);
        Saturday  = $DaysBinary.Substring(1, 1);
    }
    return $WorkingDaysInfo
}

Function CheckBusinessHours {

    $ignoreBusinessHours = Get-ItemPropertyValue -Path $ReleaseMaintenance -Name "IgnoreBusinessHours" -ErrorAction SilentlyContinue

    if ($ignoreBusinessHours -ne "1") {
    
        $BusinessHoursInfo = GetBusinessHours

        $Culture = [System.Globalization.CultureInfo]::GetCultureInfo(1033).DateTimeFormat

        $Today = (Get-Date).toString("dddd", $Culture)

        if ($BusinessHoursInfo.StartTime -eq 0) {
            [string]$BusinessHoursInfo = "00:01"
        }
        else {
            if ($BusinessHoursInfo.StartTime -lt 10) {
                [string]$StartTimeString = "0" + $BusinessHoursInfo.StartTime.ToString() + ":00"
            }
            else {
        
                [string]$StartTimeString = $BusinessHoursInfo.StartTime.ToString() + ":00"
            }
        }

        if ($BusinessHoursInfo.EndTime -eq 0) {
            [string]$EndTimeString = "23:59"
        }
        else {
            if ($BusinessHoursInfo.EndTime -lt 10) {
                [string]$EndTimeString = "0" + $BusinessHoursInfo.EndTime.ToString() + ":00"
            }
            else {
                [string]$EndTimeString = $BusinessHoursInfo.EndTime.ToString() + ":00"
            }
        }

        $StartTime = [datetime]::parseexact($StartTimeString, (Get-Culture).DateTimeFormat.ShortTimePattern, [System.Globalization.CultureInfo]::GetCultureInfo('de-DE'))
        $EndTime = [datetime]::parseexact($EndTimeString, (Get-Culture).DateTimeFormat.ShortTimePattern, [System.Globalization.CultureInfo]::GetCultureInfo('de-DE'))

        if ($BusinessHoursInfo[$Today] -eq "1") {
            if ($EndTime -gt $StartTime) {
                if ((((Get-Date) -gt $EndTime) -and ((Get-Date) -lt $StartTime.AddDays(1))) -or (((Get-Date) -lt $StartTime) -and ((Get-Date) -gt $EndTime.AddDays(-1)))) {
                    return $false
                }
                else {
                    return $true
                }
            }
            else {
                if (((Get-Date) -gt $EndTime) -and (Get-Date) -lt $StartTime) {
                    return $false
                }
                else {
                    return $true
                }
            }
        }
        else {
            return $false
        }
    }
    else {
        return $false
    }
}

$WPFcmdRun.Add_Click( {

    try {
        Set-ItemProperty -Path $ReleaseMaintenance -Name "IgnoreBusinessHours" -Value "1" -Force
        $Global:Action = "Install"
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "IgnoreBusinessHours set to 1. Ready to install."
    }
    catch {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Error" -ID 1 -Message "IgnoreBusinessHours could not be set."
        Exit 0
    }
    
    $windowMain.Close()
    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Manually startet installation. Reboot ....."
    Restart-Computer -ComputerName Localhost
        
    })

$WPFcmdSave.Add_Click( {

        if ($WPFchk_Monday.IsChecked) { $Monday = "1" }else { $Monday = "0" }
        if ($WPFchk_Tuesday.IsChecked) { $Tuesday = "1" }else { $Tuesday = "0" }
        if ($WPFchk_Wednesday.IsChecked) { $Wednesday = "1" }else { $Wednesday = "0" }
        if ($WPFchk_Thursday.IsChecked) { $Thursday = "1" }else { $Thursday = "0" }
        if ($WPFchk_Friday.IsChecked) { $Friday = "1" }else { $Friday = "0" }
        if ($WPFchk_Saturday.IsChecked) { $Saturday = "1" }else { $Saturday = "0" }
        if ($WPFchk_Sunday.IsChecked) { $Sunday = "1" }else { $Sunday = "0" }

        $workdaysBin = "0" + $Saturday + $Friday + $Thursday + $Wednesday + $Tuesday + $Monday + $Sunday

        $workingDays = [System.Convert]::ToByte($workdaysBin, 2)

        $startTime = $WPFcomboStartTime.SelectedIndex
        $endTime = $WPFcomboEndTime.SelectedIndex
        $cmClientUserSettings = [WmiClass]"\\.\ROOT\ccm\ClientSDK:CCM_ClientUXSettings"
        $businessHours = $cmClientUserSettings.PSBase.GetMethodParameters("SetBusinessHours")
        $businessHours.StartTime = $StartTime
        $businessHours.EndTime = $EndTime
        $businessHours.WorkingDays = $WorkingDays
 
        Try {
            $result = $cmClientUserSettings.PSBase.InvokeMethod("SetBusinessHours", $businessHours, $Null)
            If ($result.ReturnValue -eq 0 ) {
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "New business hours set."
                $WPFlblSaved.Content = "gespeichert"
            }
            Else {
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Failed to set SCCM client business hours."
                $WPFlblSaved.Content = "konnte nicht gespeichert werden"
            }
        }
        Catch {
            WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Failed to set SCCM client business hours."
            $WPFlblSaved.Content = "konnte nicht gespeichert werden"
        }
    })

function FillWindow {

    #Register Release
    #Read Apps from Release.xml and add apps to listbox
    $XMLContent = ReadXML -xmlpath $ReleaseXML
    $Applications = $XMLContent.ChildNodes.Applications
    if ($Applications.Apps.Count -gt 0) {
        foreach ($Apps in $Applications.Apps) {
            $WPFlistApps.items.Add($Apps) | Out-Null
        }
        $WPFtxtNotification.Text = "Auf Ihrem Client stehen diverse Applikationen zur Installation bereit. Die Applikationen werden ausserhalb ihrer Arbeitszeiten installiert. Wir erlauben uns ihren Client in dieser Zeit ohne Voranmeldung neu zu starten. Die Geschäftszeiten können unter Einstellungen angepasst werden."
    }
    else {
        $WPFtxtNotification.Text = "Keine Apps anstehend."
    }

    if ($WPFlistApps.Items) { $WPFcmdRun.IsEnabled = $true } else { $WPFcmdRun.IsEnabled = $false }

    #Register Einstellungen
    #Read SCCM Client business hours

    $WorkingDayInfo = GetBusinessHours

    $WPFcomboStartTime.SelectedIndex = $WorkingDayInfo.StartTime
    $WPFcomboEndTime.SelectedIndex = $WorkingDayInfo.EndTime

    if ($WorkingDayInfo.Sunday -eq "1") { $WPFchk_Sunday.IsChecked = $true } else { $WPFchk_Sunday.IsChecked = $false }
    if ($WorkingDayInfo.Monday -eq "1") { $WPFchk_Monday.IsChecked = $true } else { $WPFchk_Monday.IsChecked = $false }
    if ($WorkingDayInfo.Tuesday -eq "1") { $WPFchk_Tuesday.IsChecked = $true } else { $WPFchk_Tuesday.IsChecked = $false }
    if ($WorkingDayInfo.Wednesday -eq "1") { $WPFchk_Wednesday.IsChecked = $true } else { $WPFchk_Wednesday.IsChecked = $false }
    if ($WorkingDayInfo.Thursday -eq "1") { $WPFchk_Thursday.IsChecked = $true } else { $WPFchk_Thursday.IsChecked = $false }
    if ($WorkingDayInfo.Friday -eq "1") { $WPFchk_Friday.IsChecked = $true } else { $WPFchk_Friday.IsChecked = $false }
    if ($WorkingDayInfo.Saturday -eq "1") { $WPFchk_Saturday.IsChecked = $true } else { $WPFchk_Saturday.IsChecked = $false }

    $WPFlblSaved.Content = ""
}

function CheckActiveUser {

    $users = Get-CimInstance –ComputerName localhost –ClassName Win32_ComputerSystem | Select-Object UserName
    
    if ($users.UserName) {
        Return $users.UserName
    }
    else {
        Return = $false
    }
}

function Main {
    
    try {
        Get-EventLog $Eventlog -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        New-EventLog -LogName $Eventlog -Source $Eventlog -ErrorAction Ignore
    }
    
    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Script startet with parameter: $ActionParam"

    If (CheckBusinessHours) {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Script startet during business hours"
    }
    else {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Script startet outside business hours"
    }

    if (!(Test-Path $ReleaseMaintenance)) {
        New-Item -Path $ReleaseMaintenance -ItemType Directory
    }
    
    if (!(Test-Path $ReleaseMaintenanceTSStatus)) {
        New-Item -Path $ReleaseMaintenanceTSStatus -ItemType Directory
    }

    $ActiveUser = CheckActiveUser
    if ($ActiveUser) {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "User $Activeuser is logged in."
    }
    else {
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "No user is logged in."
    }
    
    $XMLContent = ReadXML -xmlpath $ReleaseXML
    $Applications = $XMLContent.ChildNodes.Applications
                

    if (($ActionTask -eq "GUI") -or ($ActiveUser -and ($Applications.Apps.Count -gt 0))) {

        FillWindow 
        
        $windowMain.ShowDialog() | Out-Null

        if ($ActionTask -eq "GUI"){
            exit 0
        }
    } 

    if ($Action -eq "Inventar") {
        WriteInventar
        WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Exit script" 
        exit 0
    }  

    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Check if any tasksequence is running."
    $TSRunning = $false
    do {
        Start-Sleep 20
        try {
            $TSEnv = New-Object -ComObject "Microsoft.SMS.TSEnvironment"
            $TSRunning = $true
        }
        catch {
            $TSRunning = $false
        }
    } while ($true -eq $TSRunning)

    $clienttype = CheckClient

    $Action = $XMLContent.Release.Action

    if ($Action -eq "Waiting") {
        
        $Applications = $XMLContent.ChildNodes.Applications
        if ($Applications.Apps.Count -gt 0) {
            if ($clienttype -eq "VDIPersonal") {
                $Action = "Install"
                $XMLContent.Release.Action = "Install"
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "New applications available. Status changed to Install"
            }
            else {   
                
                #aktuell noch keine Caching Funktion implementiert darum auch für FAT direkt install
                #$XMLContent.Release.Action = "Caching"
                #$Action = "Caching"
                #WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "New applications available. Status changed to Caching"
                $XMLContent.Release.Action = "Install"
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "New applications available. Status changed to Install"
            }
        }
        else {
            WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Status is still waiting"
            WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Exit Script"
            Exit 0  
        }
    }

    if ($Action -eq "Caching") {

        $KeyExists = CheckKeys -ReleaseXML $ReleaseXML -MaintenanceKey $MaintenanceKeysCache

        if ($KeyExists) {
            WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Caching done."
            WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Status set to install."
            $XMLContent.Release.Action = "Install"
            SaveXML -XMLContent $XMLContent -xmlpath $ReleaseXML
        }
        else {
            RunTS
        }
    }
    
    $ignoreBusinessHours = Get-ItemPropertyValue -Path $ReleaseMaintenance -Name "IgnoreBusinessHours" -ErrorAction SilentlyContinue

    if (($false -eq $ActiveUser) -or ($ignoreBusinessHours -eq 1)) {
        if ($Action -eq "Install") {
 
            if ($XMLContent.Release.SACTS) {
                if ($sibapbuild -like ("*" + $XMLContent.Release.SIBAPBuild + "*")) {
                    $XMLContent.Release.SACTS = ""
                    $XMLContent.Release.SIBAPBuild = ""
                    SaveXML -XMLContent $XMLContent -xmlpath $ReleaseXML
                }
                else {
                    RunTS -SACTS $XMLContent.Release.SACTS
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "SAC upgrade started."
                    Exit
                }

            }
        
            $InstallDone = CheckKeys -ReleaseXML $ReleaseXML -MaintenanceKey $MaintenanceKeysPackages
            $XMLContent = ReadXML -xmlpath $ReleaseXML
            $SibapReleaseTS = $XMLContent.Release.SibapTS

            if ($InstallDone) {
                if ($XMLContent.Release.SCCMCollection) {
                    $RemoveColl = RemoveFromColl -CollectionName $XMLContent.Release.SCCMCollection
                }
                $sibapBuildLevel = $XMLContent.Release.SIBAPBuildLevel
                if ($sibapBuildLevel) {
                    Set-ItemProperty -Path $MaintenanceEnv -Name "sibapbuildlevel" -Value $sibapBuildLevel -Force -ErrorAction SilentlyContinue
                    Set-ItemProperty -Path $MaintenanceEnvWow6432 -Name "sibapbuildlevel" -Value $sibapBuildLevel -Force -ErrorAction SilentlyContinue
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "SibapBuildlevel set."
                }
            
                $Applications = $XMLContent.ChildNodes.Applications
                if ($Applications.Apps.Count -gt 0) {
                    foreach ($Apps in $Applications.Apps) {
                        $node = $XMLContent.SelectSingleNode("Release/Applications/Apps[.='$Apps']")
                        $node.ParentNode.RemoveChild($node) | Out-Null    
                    } 
                }
                $XMLContent.Release.Action = "Waiting"
                $XMLContent.Release.Status = "Done"
                $XMLContent.Release.Time = ""
                $XMLContent.Release.Reboots = ""
                $XMLContent.Release.Purpose = ""
                $XMLContent.Release.SIBAPTS = ""
                $XMLContent.Release.SCCMCollection = ""

                Set-ItemProperty -Path $ReleaseMaintenance -Name "IgnoreBusinessHours" -Value "0" -Force

                SaveXML -XMLContent $XMLContent -xmlpath $ReleaseXML

                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Installation done."
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Status set to waiting."
            
                $result = Remove-ItemProperty -Path "HKLM:\SOFTWARE\Maintenance\Release\TSStatus" -Name (($SibapReleaseTS + "-Inst") -replace "_", " ") -Force -ErrorAction SilentlyContinue
                WriteInventar
            }
            else {
          
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Applications available for installation."
                $Packages = $XMLContent.ChildNodes.Packages

                $TSKeyExists = CheckTS -ReleaseXML $ReleaseXML -MaintenanceKey $MaintenanceKeysPackages
            
                if (!($TSKeyExists)) {
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Tasksequences available for installation." 
                }
            
                if ($Packages.pkg.Count -gt 0) {
            
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Packages available for installation."
                
                    $TSDeployed = Get-ItemPropertyValue -Path $ReleaseMaintenanceTSStatus -Name ($SibapReleaseTS + "-Inst") -ErrorAction SilentlyContinue
                    if ($TSDeployed -ne "Deployed") {
                        $deployed = DeployTS -TSName $SibapReleaseTS
                    }

                }
            
                WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Start running tasksequences."
                RunTS -SibapReleaseTS $SibapReleaseTS
            
            
                <#
            if (!($TSDeploy)){
            
                if ($Packages.pkg.Count -gt 0)
                {
                    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Additional taskseqeunces are available for installation"
                    DeployTS -TSName $SibapReleaseTS
                    RunTS -SibapReleaseTS $SibapReleaseTS 
                }
                else
                {
                    RunTS -AdditionalTS $True
                }

            }
            else
            {
                DeployTS -TSName $SibapReleaseTS
                RunTS -SibapReleaseTS $SibapReleaseTS
            }


            #>
                <#
            if ($clienttype -eq "VDIPersonal") {
                RunTS
            }
            else {
                $Applications = $XMLContent.ChildNodes.Applications

                if ($Applications.Apps.Count -gt 0) {

                    foreach ($Apps in $Applications.Apps) {
                        $WPFlistApps.Items.Add($Apps)
                    }
                }

                FillWindow
                $windowMain.ShowDialog() | Out-Null
            }
            #>
            }
        }
    }
    WriteLog -Log $Eventlog -Source $Eventlog -Type "Info" -ID 1 -Message "Script Finished"
}

Main