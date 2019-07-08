# Functions
function Write-LogEntry {
    param(
        [parameter(Mandatory=$true, HelpMessage="Value added to the RemovedApps.log file.")]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [parameter(Mandatory=$false, HelpMessage="Name of the log file that the entry will written to.")]
        [ValidateNotNullOrEmpty()]
        [string]$FileName = "RemovedApps.log"
    )
    # Determine log file location
    $LogFilePath = Join-Path -Path $env:windir -ChildPath "Temp\$($FileName)"

    # Add value to log file
    try {
        Out-File -InputObject $Value -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning -Message "Unable to append log entry to RemovedApps.log file"
    }
}

# Get a list of all apps
Write-LogEntry -Value "Starting built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"
$AppArrayList = Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Select-Object -Property Name, PackageFullName | Sort-Object -Property Name

# White list of appx packages to keep installed
$WhiteListedApps = New-Object -TypeName System.Collections.ArrayList
$WhiteListedApps.AddRange(@(
    "1527c705-839a-4832-9118-54d4Bd6a0c89",
    "c5e2524a-ea46-4f67-841f-6a9465d9d515", 
    "E2A4F912-2574-4A75-9BB0-0D023378592B",
    "F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE",
    "InputApp",
    "Microsoft.AAD.BrokerPlugin",
    "Microsoft.AccountsControl",
    "Microsoft.AsyncTextService",
    "Microsoft.BioEnrollment",
    "Microsoft.CredDialogHost",
    "Microsoft.ECApp",
    "Microsoft.LockApp",
    "Microsoft.MicrosoftEdge",
    "Microsoft.PPIProjection",
    "Microsoft.Win32WebViewHost",
    "Microsoft.Windows.Apprep.ChxApp",
    "Microsoft.Windows.AssignedAccessLockApp",
    "Microsoft.Windows.CapturePicker", 
    "Microsoft.Windows.CloudExperienceHost",
    "Microsoft.Windows.ContentDeliveryManager",
    "Microsoft.Windows.Cortana",
    "Microsoft.Windows.NarratorQuickStart",
    "Microsoft.Windows.OOBENetworkCaptivePortal",
    "Microsoft.Windows.OOBENetworkConnectionFlow",
    "Microsoft.Windows.ParentalControls",
    "Microsoft.Windows.PeopleExperienceHost",
    "Microsoft.Windows.PinningConfirmationDialog",
    "Microsoft.Windows.SecHealthUI",
    "Microsoft.Windows.SecureAssessmentBrowser",
    "Microsoft.Windows.ShellExperienceHost",
    "Microsoft.Windows.XGpuEjectDialog",
    "Windows.CBSPreview",
    "windows.immersivecontrolpanel",
    "Windows.PrintDialog",
    "Microsoft.NET.Native.Runtime.1.7",
    "Microsoft.NET.Native.Runtime.1.6",
    "Microsoft.WebpImageExtension",
    "Microsoft.Getstarted",
    "Microsoft.VCLibs.140.00",
    "Microsoft.NET.Native.Runtime.2.2",
    "Microsoft.NET.Native.Framework.2.2",                 
    "Microsoft.UI.Xaml.2.0",
    "Microsoft.VCLibs.140.00.UWPDesktop",
    "Microsoft.Messaging",
    "Microsoft.NET.Native.Framework.1.7",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsMaps",
    "Microsoft.ScreenSketch",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.MSPaint",                     
    "Microsoft.WindowsAlarms",
    "Microsoft.People",
    "Microsoft.Windows.Photos",         
    "Microsoft.WebMediaExtensions",            
    "microsoft.windowscommunicationsapps",
    "Microsoft.WindowsCalculator",
    "Microsoft.NET.Native.Framework.1.6",    
    "Microsoft.DesktopAppInstaller",
    "Microsoft.Services.Store.Engagement",
    "Microsoft.StorePurchaseApp",
    "Microsoft.HEIFImageExtension",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.OneConnect",                   
    "Microsoft.GetHelp",                                              
    "Microsoft.Office.OneNote",
    "Microsoft.BingWeather",
    "Microsoft.BingNews",
    "Microsoft.Office.Sway",
    "Microsoft.NET.Native.Runtime.1.4",
    "Microsoft.VCLibs.120.00.Universal",
    "Microsoft.OfficeLens",
    "Microsoft.RemoteDesktop",
    "Microsoft.NET.Native.Framework.1.3",
    "Microsoft.Todos",
    "Microsoft.NET.Native.Runtime.2.1",       
    "Microsoft.NET.Native.Framework.2.1",
    "Microsoft.Whiteboard",
    "Microsoft.MicrosoftEdgeDevToolsClient",
    "Microsoft.VP9VideoExtensions",
    "Microsoft.VCLibs.120.00.UWPDesktop",     
    "Microsoft.BingTranslator",
    "Microsoft.LanguageExperiencePackde-DE",
    "Microsoft.NET.Native.Runtime.2.0",
    "Microsoft.WindowsStore",        
    "Microsoft.YourPhone",
    "Microsoft.Whiteboard",
    "microsoft.windowscommunicationsapps",
    "Microsoft.BingNews",     
    "Microsoft.WindowsCalculator",
    "Microsoft.Todos"

))

# Windows 10 version 1903
$WhiteListedApps.AddRange(@(

))

# Loop through the list of appx packages
foreach ($App in $AppArrayList) {
    # If application name not in appx package white list, remove AppxPackage and AppxProvisioningPackage
    if (($App.Name -in $WhiteListedApps)) {
        Write-LogEntry -Value "Skipping excluded application package: $($App.Name)"
    }
    else {
        # Gather package names
        $AppPackageFullName = Get-AppxPackage -Name $App.Name | Select-Object -ExpandProperty PackageFullName -First 1
        $AppProvisioningPackageName = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $App.Name } | Select-Object -ExpandProperty PackageName -First 1

        # Attempt to remove AppxPackage
        if ($AppPackageFullName -ne $null) {
            try {
                Write-LogEntry -Value "Removing AppxPackage: $($AppPackageFullName)"
                Remove-AppxPackage -Package $AppPackageFullName -ErrorAction Stop | Out-Null
            }
            catch [System.Exception] {
                Write-LogEntry -Value "Removing AppxPackage '$($AppPackageFullName)' failed: $($_.Exception.Message)"
            }
        }
        else {
            Write-LogEntry -Value "Unable to locate AppxPackage: $($AppPackageFullName)"
        }

        # Attempt to remove AppxProvisioningPackage
        if ($AppProvisioningPackageName -ne $null) {
            try {
                Write-LogEntry -Value "Removing AppxProvisioningPackage: $($AppProvisioningPackageName)"
                Remove-AppxProvisionedPackage -PackageName $AppProvisioningPackageName -Online -ErrorAction Stop | Out-Null
            }
            catch [System.Exception] {
                Write-LogEntry -Value "Removing AppxProvisioningPackage '$($AppProvisioningPackageName)' failed: $($_.Exception.Message)"
            }
        }
        else {
            Write-LogEntry -Value "Unable to locate AppxProvisioningPackage: $($AppProvisioningPackageName)"
        }
    }
}

# White list of Features On Demand V2 packages
Write-LogEntry -Value "Starting Features on Demand V2 removal process"
$WhiteListOnDemand = "NetFX3|Tools.Graphics.DirectX|Tools.DeveloperMode.Core|Language|Browser.InternetExplorer|ContactSupport|OneCoreUAP|Media.WindowsMediaPlayer"

# Get Features On Demand that should be removed
try {
    $OSBuildNumber = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object -ExpandProperty BuildNumber

    # Handle cmdlet limitations for older OS builds
    if ($OSBuildNumber -le "16299") {
        $OnDemandFeatures = Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed"} | Select-Object -ExpandProperty Name
    }
    else {
        $OnDemandFeatures = Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed"} | Select-Object -ExpandProperty Name
    }

    foreach ($Feature in $OnDemandFeatures) {
        try {
            Write-LogEntry -Value "Removing Feature on Demand V2 package: $($Feature)"

            # Handle cmdlet limitations for older OS builds
            if ($OSBuildNumber -le "16299") {
                Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
            }
            else {
                Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
            }
        }
        catch [System.Exception] {
            Write-LogEntry -Value "Removing Feature on Demand V2 package failed: $($_.Exception.Message)"
        }
    }    
}
catch [System.Exception] {
    Write-LogEntry -Value "Attempting to list Feature on Demand V2 packages failed: $($_.Exception.Message)"
}

# Complete
Write-LogEntry -Value "Completed built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"Get-AppxDefaultVolume