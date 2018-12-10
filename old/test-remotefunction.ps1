#region Exists-RegValue
function Exists-RegValue
{
	param ([Parameter(Mandatory=$True)][string]$RegPath, [string]$ValueName, [string]$computername) 
	try
	{	if($computername -eq $null)
         {
		#Write-Host "existiert? " $ValueName
		Get-ItemProperty $RegPath $ValueName -ErrorAction SilentlyContinue | Out-Null
		$?
        #Write-LogFile -LogFile $LogFullName -Message "function returned $?"
         }
         else
          {
          $remotecommand = {param ($RegPath,$ValueName);Get-ItemProperty $RegPath $ValueName}
          #$scriptblock = [scriptblock]::Create($remotecommand)
          Invoke-Command  -ComputerName $computername -ScriptBlock $remotecommand -ArgumentList $RegPath, $ValueName
          $?
          }
	}
	catch [System.SystemException]
	{
		$errormessage = "Error in Function " + $MyInvocation.InvocationName + [Environment]::NewLine + $Error[0]
		#Write-LogFile -LogFile $LogFullName -Message $errormessage
		Remove-Variable errormessage
	}
	finally
	{
		remove-variable RegPath
		remove-variable ValueName
	}
}
#endregion
$e = $null
$e = (Exists-RegValue -RegPath "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -ValueName "cadca5fe-87d3-4b96-b7fb-a231484277cc" -computername "srv-sccm-001")
$e