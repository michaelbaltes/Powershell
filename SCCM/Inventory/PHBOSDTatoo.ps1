############################################################################################################################
#
# PHBern - Windows Server 2016 - OSD - Inventar
#
# Version 1.4
#
# Created by F. Calcio-Gandino / Unisys
# Modified by V. Albornoz / PHBern - creation of PHBernReleaseName and PHBernReleaseName, if elseif else neu erstellt mit Abfrage auf
# TSPackageName für PRD;INT und TST und Installationsstatus hinzugefügt.
############################################################################################################################
#
# Define Variables
#
$TSENV = New-Object -COMObject Microsoft.SMS.TSEnvironment
$OSInfo = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$RegPath = "HKLM:\SOFTWARE\"
$RegKeyPHB =  "PHBernOSD"
$RegPathPHB = "HKLM:\SOFTWARE\PHBernOSD"
$Date = get-date -UFormat "%Y%m%d"
#$ProductName = Get-ItemProperty -Path $OSInfo -Name "ProductName"
$ReleaseID = Get-ItemProperty -Path $OSInfo -Name "ReleaseId"
#$CurrentBuild = Get-ItemProperty -Path $OSInfo -Name "CurrentBuild"
# Create HKLM:\SOFTWARE\PHBern Path
New-Item -Path $RegPath -Name $RegKeyPHB
#Split TS Name:
$TSName = $TSENV.Value("_SMSTSPackageName")
$TSName = $TSName.Split("-")
$Umgebung = $TSName[0]
$InstallRelease = $TSName[1]
$PHBernReleaseName = $TSName[2]
$PHBernReleaseNumber = $TSName[1]


if ($Umgebung -eq 'PRD')
{
    # Set Registry Key Task Sequence Package & Installation State
    #
    Set-ItemProperty -Path $RegPathPHB -Name "InstallTsName" -Value $TSENV.Value("_SMSTSPackageName")
   
    Set-ItemProperty -Path $RegPathPHB -Name "InstallState" -Value $TSENV.Value("_SMSTSLastActionSucceeded")
    #
    #Change Registry Value for LastActionSucceeded from true to success:
    #
    if ($TSENV.Value("_SMSTSLastActionSucceeded") -eq 'true')
    {
        Set-ItemProperty -Path $RegPathPHB -Name "InstallState" -Value 'success'
    }
    else
    {
     Set-ItemProperty -Path $RegPathPHB -Name "InstallState" -Value 'failed'
    }
    # Set Registry Key Install Data:
    #
    Set-ItemProperty -Path $RegPathPHB -Name "InstallDate" -Value $Date
    #
    #Set Registry Key Windows Product Name, Release and Build:
    #
    #Set-ItemProperty -Path $RegPathPHB -Name "ProductName" -Value $ProductName.ProductName
    #
    Set-ItemProperty -Path $RegPathPHB -Name "WindowsRelease" -Value $ReleaseID.ReleaseId
    #
    #Set-ItemProperty -Path $RegPathPHB -Name "WindowsBuild" -Value $CurrentBuild.CurrentBuild
    #
    Set-ItemProperty -Path $RegPathPHB -Name "InstallRelease" -Value $InstallRelease
    #
    #set regkeys to Null for inventary:
    #
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateTsName" -Value 'none'
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateState" -Value 'none'
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateDate" -Value 'none'
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateRelease" -Value 'none'
    #
    # Set PHBernRelease Number
    #
    Set-ItemProperty -Path $RegPathPHB -Name "PHBernReleaseNumber" -Value $PHBernReleaseNumber
}

    #Set Registry Keys for Update Release:    
elseif ($Umgebung -eq 'UPD') 
{
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateTsName" -Value $TSENV.Value("_SMSTSPackageName")
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateState" -Value $TSENV.Value("_SMSTSLastActionSucceeded")
    if ($TSENV.Value("_SMSTSLastActionSucceeded") -eq 'true')
    {
        Set-ItemProperty -Path $RegPathPHB -Name "UpdateState" -Value 'success'
    }
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateDate" -Value $Date
    Set-ItemProperty -Path $RegPathPHB -Name "UpdateRelease" -Value $InstallRelease
    Set-ItemProperty -Path $RegPathPHB -Name "PHBernReleaseNumber" -Value $PHBernReleaseNumber
}
    #Set Registry Keys for Test Installations:   
else
{   
    Set-ItemProperty -Path $RegPathPHB -Name "InstallTsName" -Value $TSENV.Value("_SMSTSPackageName")
    Set-ItemProperty -Path $RegPathPHB -Name "InstallState" -Value $TSENV.Value("_SMSTSLastActionSucceeded")
    if ($TSENV.Value("_SMSTSLastActionSucceeded") -eq 'true')
    {
        Set-ItemProperty -Path $RegPathPHB -Name "InstallState" -Value 'success'
    }
    Set-ItemProperty -Path $RegPathPHB -Name "InstallDate" -Value $Date
    Set-ItemProperty -Path $RegPathPHB -Name "InstallRelease" -Value $InstallRelease  
    Set-ItemProperty -Path $RegPathPHB -Name "PHBernReleaseNumber" -Value $PHBernReleaseNumber
}
  
  

    
# End
#
############################################################################################################################