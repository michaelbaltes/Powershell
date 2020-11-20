<#
.Synopsis
    Generates differential or full backup

.DESCRIPTION
    This Script generates a differential or a full backup of folders and files maintaining the source path's file structure at the destination path. The differential backup will copy all files newer than the given threshhold date and time.

.INPUTS
    None

.OUTPUTS
    Backup at user defined destination path
    Log file at destination path

.NOTES
    Script name:    Start-Backup.ps1
    Author:         Krishanth Rajkumar
    Version:        1.3

    History:        V1.3    18.08.2020  Krishanth Rajkumar      Changed script header to a more conventional format
                    V1.2    12.03.2020  Krishanth Rajkumar      Restructured region "main" for better streamlining
                                                                Progressbar now works for both backup types and shows percentage as number, too
                                                                Now logging script variables (except log path)
                                                                Added some general log statements
                                                                Added annotation
                    V1.1    08.03.2020  Krishanth Rajkumar      Progressbar and better logging for full backup
                    V1.0	05.03.2020	Krishanth Rajkumar	    Created
                    
#>

#region functions
#============================================================================================================================
Function Write-Log {
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [ValidateSet('ok','info','warning','error')]
        [string]$Severity = 'info'
    )

    #write to log file
    $Message = "$(Get-Date -Format G); $Severity; $Message"
    $Message | Out-File -FilePath $script:logPath -Append

    #write to console with color depending on severity
    [string]$Color = ""
    switch ($Severity) {
        'ok' {$Color = "Green"}
        'warning' {$Color = "Yellow"}
        'error' {$Color = "Red"}
        default {$Color = "White"}
    }
    Write-Host -ForegroundColor $Color $Message
}

Function Set-SourcePath {
    #to use this script for backups in general, use the do-while-loop instead of hardcoding the source path
    do {
        $script:sourcePath = (Get-Item (Read-Host "Enter backup source path (case sensitive!)").Trim('"')).FullName
    } while (!(Test-Path $script:sourcePath))
}

Function Set-DestinationPath {
    $destinationParentPath = (Get-Item (Read-Host "Path to destination folder (case sensitive!)").Trim('"')).FullName

    $destinationFolderName = Read-Host "Name of the destination folder (creates new folder - leave empty if not needed)"

    $script:destinationPath = "$destinationParentPath\$destinationFolderName"

    $currentDate = Get-Date -Format G
    if ($destinationFolderName -eq "") {$destinationFolderName = "$($currentDate.Split(' ')[0].Split('.')[2])-$($currentDate.Split(' ')[0].Split('.')[1])-$($currentDate.Split(' ')[0].Split('.')[0])-$($currentDate.Split(' ')[1].Split(':')[0])-$($currentDate.Split(' ')[1].Split(':')[1])"}
    $script:logPath = "$destinationParentPath\$destinationFolderName.log"
}

Function Set-BackupType {
    $backupTypeChoice = Read-Host "Full backup (f) or differential backup (d)? (default is d)"

    switch ($backupTypeChoice) {
        'f' {return "full"}
        default {return "differential"}
    }
}

Function Set-ThreshholdDate {
    $script:threshholdDateAndTime = Read-Host "Copy all files newer than (dd.mm.yyyy HH:mm)" | Get-Date
}

Function SourceFiles {
    Get-ChildItem -Path $script:sourcePath -Recurse
}

Function ObjectIsAFileNewerThanThreshholdDate {
    param (
        $Object
    )

    if ($Object.LastWriteTime -ge $script:threshholdDateAndTime) {
        if (!($Object.PSIsContainer)) {
            return $true
        }
        else {return $false}
    }
    else {
        Write-Log -Message "Did not copy $Object because it is older than threshold date" -Severity warning
        return $false
    }
}

Function CopyFileToDestinationWithEqualStructure {
    param (
        $File
    )

    $fullDestinationPath = $script:destinationPath + $File.FullName.Replace("$script:sourcePath","")
    $fullDestinationFolder = $fullDestinationPath.Replace($File.Name,"")
    try {
        if (!(Test-Path $fullDestinationFolder)) {
            New-Item -Path $fullDestinationFolder -ItemType Directory | Out-Null
        }
        Copy-Item -Path $File.FullName -Destination $fullDestinationPath -Recurse
        Write-Log -Message "Copied $File to $fullDestinationPath" -Severity ok
    } catch {
        Write-Log -Message "Failed to copy $File to $fullDestinationPath" -Severity error
    }
}
#endregion functions

#region script variables
#============================================================================================================================
<#
$script:sourcePath
$script:destinationPath
$script:logPath
$script:threshholdDateAndTime
#>
#endregion script variables

#region main
#============================================================================================================================
Set-SourcePath
Set-DestinationPath

$backupType = Set-BackupType
if ($backupType -eq "differential") {Set-ThreshholdDate}

Write-Log -Message "Source path set to $script:sourcePath"
Write-Log -Message "Destination path set to $script:destinationPath"
if ($backupType -eq "differential") {Write-Log -Message "Only copying files newer than $script:threshholdDateAndTime"}

Write-Log -Message "Starting $backupType backup"

$numberOfFiles = (SourceFiles).Count
$currentFileNumber = 1
foreach ($object in SourceFiles) {
    $percentage = $currentFileNumber / $numberOfFiles * 100
    Write-Progress -Activity "Creating $backupType backup of $script:sourcePath to $script:destinationPath" -Status "Processing file $currentFileNumber/$numberOfFiles - about $($percentage.ToString().Split('.')[0])% complete" -PercentComplete $percentage
    
    switch ($backupType) {
        "full" {
            if (!($object.PSIsContainer)) {
                CopyFileToDestinationWithEqualStructure -File $object
            }
            else {
                if (($object | Get-ChildItem).Count -eq 0) {
                    CopyFileToDestinationWithEqualStructure -File $object
                }
            }
        }

        "differential" {
            if (ObjectIsAFileNewerThanThreshholdDate -Object $object) {
                CopyFileToDestinationWithEqualStructure -File $object
            }
        }
    }

    $currentFileNumber++
}

Write-Log -Message "Backup process completed." -Severity ok
Write-Host "For further information consult log at $script:logPath"
#endregion main