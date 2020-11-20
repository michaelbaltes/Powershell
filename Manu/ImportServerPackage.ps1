using module "C:\Program Files\avatex\Modules\Settings.psm1"
using module "C:\Program Files\avatex\Modules\Logging.psm1"
using module "C:\Program Files\avatex\Modules\AppVMgmtSRV.psm1"


[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]
    [string]$Path,
[Parameter(Mandatory = $True, Position = 2)]
    [string]$MachineConfig,
[Parameter(Mandatory = $True, Position = 3)]
    [string]$UserConfig,
[Parameter(Mandatory = $True, Position = 4)]
    [string]$ADGroup,
[Parameter(Mandatory = $True, Position = 5)]
    [string]$Override
    )


$ErrorActionPreference = "Stop"

Import-Module "C:\Program Files\avatex\Modules\ExportAppXManifest.psm1"

$Space = '"'

$Settings = [ToolsSettings]::New()
$Logging = [WriteLog]::New($Settings.ProgressLog, $MyInvocation.MyCommand.Name)

try
{
    $AppVServer = [AppVServer]::New($Settings.AppVMgmtSRV, $Settings.PWDLog)
    $logging.LogEntry("Sucess", "Object AppvServer created")
}
catch
{
    $logging.LogEntry("Eror", "Unable to create AppvServer object: $_.Exception.Message")
}

$Logging.LogEntry("Info", "Import package started")
$Logging.LogEntry("Info", "Path: $Path, MachineConfig: $MachineConfig, UserConfig: $UserConfig, Publishing: $Publishing, Override: $Override")

ExportAppXManifest -PackagePath $Path -Exportpath "$Env:TEMP"

$PackageName = GetPKGNameFromAppxManifest -XMLPath "$Env:TEMP\AppxManifest.xml"
$Logging.LogEntry("Info", "PackageName: $PackageName")

try
{
    $AppVServer.GetPackageByName($PackageName)
    $Logging.LogEntry("Success", "Check for existing package")
}
catch
{
    $Logging.LogEntry("Error", "Check for existing package error: $_.Exception.Message")
    return 1
}

if($AppVServer.PackageByName -and $Override -ne "1")
{
    $Logging.LogEntry("Error", "Package $PackageName allready exists and override package ist not selected.")
    return 1
}

if($AppVServer.PackageByName -and $Override -eq "1")
{
    try
    {
        $AppVServer.RemovePackage($PackageName)
        $Logging.LogEntry("Success", "Package $PackageName removed successful")
    }
    catch
    {
        $Logging.LogEntry("Error", "Delete package error: $_.Exception.Message")
    }
}

try
{
    $AppVServer.ImportPackage($Path)
    $Logging.LogEntry("Success", "Package importet")
    $return = "0"
}
catch
{
    $Logging.LogEntry("Error", "Package import error: $_.Exception.Message")
    return 1
}

if($MachineConfig -ne "0" -or $UserConfig -ne "0")
{
    try
    {
        $AppVServer.ImportConfig($AppVServer.ImportedPackage.PackageGuid, $AppVServer.ImportedPackage.VersionGuid, $MachineConfig, $UserConfig)
        $Logging.LogEntry("Success", "Config importet")
        $return = "0"
    }
    catch
    {
        $Logging.LogEntry("Error", "Package import error: $_.Exception.Message")
        return 1
    }
}

if($ADGroup -ne "0")
{
    try
    {
        $AppVServer.GrantGroup($ADGroup, $AppvServer.ImportedPackage.Name)
        $Logging.LogEntry("Success", "Package granted for group $ADGroup")
        $return = "0"
    }
    catch
    {
        $Logging.LogEntry("Error", "grant group error: $_.Exception.Message")
        return 1
    }
}

return $return