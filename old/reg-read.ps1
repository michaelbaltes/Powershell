#region Write-Logifile
function Write-LogFile
{
	param ([Parameter(Mandatory=$True)][string]$LogFile, [string]$Message) 
	try 
	{
		$LogFilePath = split-path -Path $LogFile
		if (!(Test-Path $LogFilePath))
            {New-Item $LogFilePath -type directory }
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


#region Exists-RegValue
function Exists-RegValue
{
	param ([Parameter(Mandatory=$True)][string]$RegPath, [string]$ValueName) 
	try
	{	
		#Write-Host "existiert? " $ValueName
		Get-ItemProperty $RegPath $ValueName -ErrorAction SilentlyContinue | Out-Null
		$?
        Write-LogFile -LogFile $LogFullName -Message "function returned $?"
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


$server = Get-Content C:\_MBA\data\serverliste.txt
[string]$script:ScriptName = split-path $MyInvocation.MyCommand.Path -Leaf
[string]$script:LogPath = "c:\scripts\data\CheckReg"
[string]$script:LogFullName = $LogPath + "\" + $ScriptName + ".log"



Write-LogFile -LogFile $LogFullName -Message "Run Script"
foreach ($computer in $server){

Invoke-Command -ComputerName $computer -ScriptBlock {
    
    $regkey = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat"
    $regvalue = "cadca5fe-87d3-4b96-b7fb-a231484277cc"
    Get-ItemProperty $regkey $regvalue -ErrorAction SilentlyContinue | Out-Null 
    $?
    }
Write-LogFile -LogFile $LogFullName -Message " For $computer was returned $? "
}
Write-LogFile -LogFile $LogFullName -Message "Run Script ended"