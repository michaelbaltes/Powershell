<#---------------------------------------------------------------------------------------------------------------------------
Name: 			LoadReg.ps1
Author: 		Bedag Informatik
Version: 		0.1
Description: 	
										
Syntax:			

Changelog:
			V0.1	25.06.2014	Michael Baltes	 Created

			JGK PRD: INT: 			\\a2va-cfs-tsusr0.infra.be.ch\usr0\LoadReg
			JGK TST, ENT, SCH: 		\\a2va-cfs-tsusr0.infra.be.ch\usr0\LoadReg 
			Justiz PRD: INT:		\\a2va-cfs-tsusr1.infra.be.ch\usr1\LoadReg
			Justiz TST, ENT, SCH: 	\\a2va-cfs-tsusr1.infra.be.ch\usr1\LoadReg 
---------------------------------------------------------------------------------------------------------------------------#>

$ErrorActionPreference = "stop"

#---------------------------------------------------------------------------------------------------------------------------
# Global Variables
#---------------------------------------------------------------------------------------------------------------------------

[string]$script:ScriptPath = split-path $MyInvocation.MyCommand.Path
#[string]$script:MessagePath = $ScriptPath + "\input.txt"
[string]$script:ScriptName = split-path $MyInvocation.MyCommand.Path -Leaf
[string]$script:LogPath = "$($Env:APPDATA)\LoadReg"
[string]$script:LogFullName = $LogPath + "\" + $ScriptName + ".log"
[string]$script:FirstRunReg = "HKCU:\Software\Bedag\loadReg\"
[string]$script:LoadRegShareJGKPrd = "\\a2va-cfs-tsusr0.infra.be.ch\usr0\LoadReg"
[string]$script:LoadRegShareJGKTST = "\\a2va-cfs-tsusr0.infra.be.ch\usr0\LoadReg"
[string]$script:LoadRegShareJustizPrd = "\\a2va-cfs-tsusr1.infra.be.ch\usr1\LoadReg"
[string]$script:LoadRegShareJustizTST = "\\a2va-cfs-tsusr1.infra.be.ch\usr1\LoadReg"

[string]$script:TestShare = "c:\temp\loadreg"

#---------------------------------------------------------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------------------------------------------------------

#region Write-Logifile
function Write-LogFile
{
	param ([Parameter(Mandatory=$True)][string]$LogFile, [string]$Message) 
	try 
	{
		$LogFilePath = split-path -Path $LogFile
		if (!(Exists-Folder($LogFilePath))) {Create-NewFolder $LogFilePath}
		$Message = (get-date -uformat "%d.%m.%Y - %H:%M:%S") + " - " + $Message
		Write-Host $Message
		$Message| Out-File -filepath ($LogFile)  -append
	}
	catch [System.SystemException]
	{

	}
	finally
	{
		Remove-Variable Message
	}
}
#endregion

#region Create-NewFolder
function Create-NewFolder
{
	param ([Parameter(Mandatory=$True)][string]$NewFolderpath) 
	try
	{
		if (!(Test-Path -path $NewFolderpath))
		{
			New-Item $Newfolderpath -type directory | Out-Null
		}
	}
	catch
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
}
#endregion

#region Exists-Folder
function Exists-Folder
{
	param ([Parameter(Mandatory=$True)][string]$folderpath) 
	try
	{
		if (Test-Path -path $folderpath)
		{
			return $true		
		}
		else
		{
			return $false
		}	
	}
	catch [System.SystemException]
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
	finally
	{
		remove-variable folderpath
	}
}
#endregion

#region Exists-RegValue
function Exists-RegValue
{
	param ([Parameter(Mandatory=$True)][string]$RegPath, [string]$ValueName) 
	try
	{	
		#Write-Host "existiert? " $ValueName
		Get-ItemProperty $RegPath $ValueName -ErrorAction SilentlyContinue | Out-Null
		$?
	}
	catch [System.SystemException]
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
	finally
	{
		remove-variable RegPath
		remove-variable ValueName
	}
}
#endregion

#region Read-RegKey
function Read-RegKey
{
	param ([Parameter(Mandatory=$True)][string]$regpath, [Parameter(Mandatory=$True)][string]$regkey)
	try
	{
		(Get-ItemProperty -path $regpath -ErrorAction Stop).$regkey
	}
	catch [System.SystemException]
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
	finally
	{
		remove-variable regpath 
		remove-variable regkey
	}
}
#endregion

#region Write-RegKeySZ
function Write-RegKeySZ
{
	param ([Parameter(Mandatory=$True)][string]$regpath, [Parameter(Mandatory=$True)]$regkey, [Parameter(Mandatory=$True)][string]$regvalue)
	if (!(Exists-RegKey $regpath))
	{
		Create-RegKey $regpath
	}
	try
	{
		Set-ItemProperty -path $regpath -name $regkey -value $regvalue -ErrorAction Stop
	}
	catch [System.SystemException]
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
	finally
	{
		remove-variable regpath 
		remove-variable regkey 
		remove-variable regvalue
	}
}
#endregion

#region Exists-RegKey
function Exists-RegKey
{
	param ([Parameter(Mandatory=$True)][string]$regpath) 
	try
	{
		if (Test-Path -path $regpath)
		{
    		return $true		
		}
		else
		{
			return $false
		}	
	}
	catch [System.SystemException]
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
	finally
	{
		remove-variable regpath
	}
}
#endregion

#region Create-RegKey
function Create-RegKey
{
	param ([Parameter(Mandatory=$True)][string]$regpath) 
	try
	{
		Write-Host $regpath
		New-Item -Path $regpath -Force
	}
	catch [System.SystemException]
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
	finally
	{
		remove-variable regpath
	}
}
#endregion

#region Get-FileNames
function Get-FileNames
{
	param ([Parameter(Mandatory=$true)][string]$filepath, [Parameter(Mandatory=$true)][string]$Fileextension)
	try
	{
	$filenamearray = Get-ChildItem "$filepath\*$Fileextension" |%{($_.PSChildname)} 
	$filenamearray 
	}
	catch [System.SystemException]
	{
	
	}
	finally
	{
		remove-variable filepath
	}
}
#endregion


#---------------------------------------------------------------------------------------------------------------------------
# Main
#---------------------------------------------------------------------------------------------------------------------------

try
{
	Write-LogFile -LogFile $LogFullName -Message "Run LoadReg"
	
	foreach($regfilename in (get-FileNames -filepath $script:TestShare -Fileextension ".reg"))
		{
			If (!(Exists-RegValue -regPath $FirstRunReg -ValueName $regfilename))
			{
				Write-LogFile -LogFile $LogFullName -Message "Regvalue: $regfilename not exists. Import file now! - control Logfile $LogPath\$regfilename.log"
				Start-Process -WorkingDirectory $env:windir -FilePath "$($env:windir)\regedit.exe" -Argument  "/m /s $script:TestShare\$regfilename" -RedirectStandardError `
				"$LogPath\$regfilename _error.log" -RedirectStandardOutput "$LogPath\$regfilename.log" 
				sleep -Seconds 3
				New-ItemProperty -Path $FirstRunReg -Name $regfilename -Value (get-date -uformat "%d.%m.%Y - %H:%M:%S") -PropertyType "string"
			
			}
			else
			{
				Write-LogFile -LogFile $LogFullName -Message "Regvalue: $$regfilename exists. Exit now, nothing to do!"
			}
		}
	
}
catch
{
	Write-Logfile -logfile $LogFullName -message "Error in Line: $($Error[0].InvocationInfo.ScriptLineNumber) -> ErrorMessage: $($Error[0])"
}