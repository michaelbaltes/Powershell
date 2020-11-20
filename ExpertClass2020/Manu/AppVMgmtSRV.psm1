$ErrorActionPreference = "Stop"

Class AppVServer
{

    $session
    [string]$Server
    [string]$PWDFile
    [array]$AllPackages
    [array]$PackageByName
    [array]$PackageByID
    [array]$ImportedPackage
    

    #Constructor
    AppVServer([string]$Server, [string]$PWDFile)
    {
        
        $this.Server = $Server
        $this.PWDFile = $PWDFile
        
        $CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        if(!(Test-Path $this.PWDFile))
        {
            $PW = Read-Host -AsSecureString -Prompt "Please enter password for user: $CurrentUser" | ConvertFrom-SecureString
            $PW | Out-File "$env:TEMP\appvpwd.txt"

        }
            $PW = cat $this.PWDFile | ConvertTo-SecureString

            $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $CurrentUser,$PW
            $this.session = New-PSSession $this.Server -Authentication Credssp -Credential $Credentials

    }

    GetAllPackages()
    {
        $this.AllPackages = Invoke-Command -Session $this.session -Script {Get-AppvServerPackage}
    }

    GetPackageByName([string]$PackageName)
    {
        $this.PackageByName = Invoke-Command -Session $this.session -Script {param($PackageNameParam)Get-AppvServerPackage $PackageNameParam} -ArgumentList $PackageName
    }

    GetPackageByID([string]$PackageGUI)
    {
        $this.PackageByID = Invoke-Command -Session $this.session -Script {param($PackagGUIParam)Get-AppvServerPackage -PackageID $PackagGUIParam} -ArgumentList $PackageGUI
    }


    ImportPackage([string]$PackagePath)
    {
        $this.ImportedPackage = Invoke-Command -Session $this.session -Script {param($PackagePathParam)Import-AppvServerPackage -PackagePath $PackagePathParam} -ArgumentList $PackagePath
    }

    ImportConfig([string]$PackageID, [string]$VersionID,[string]$MachinConfig, [string]$UserConfig)
    {
        
        if($MachinConfig -ne "0" -and $UserConfig -ne "0")
        {
            Invoke-Command -Session $this.session -Script {param($PackageIDParam, $VersionIDParam, $MachinConfigParam, $UserConfigParam)Set-AppvServerPackage -PackageID $PackageIDParam -DynamicDeploymentConfigurationPath $MachinConfigParam -DynamicUserConfigurationPath $UserConfigParam -VersionID $VersionIDParam} -ArgumentList $PackageID, $VersionID, $MachinConfig, $UserConfig
        }
        if($MachinConfig -ne "0" -and $UserConfig -eq "0")
        {
            Invoke-Command -Session $this.session -Script {param($PackageIDParam, $VersionIDParam, $MachinConfigParam)Set-AppvServerPackage -PackageID $PackageIDParam -DynamicDeploymentConfigurationPath $MachinConfigParam -VersionID $VersionIDParam} -ArgumentList $PackageID, $VersionID, $MachinConfig
        }
        if($MachinConfig -eq "0" -and $UserConfig -ne "0")
        {
            Invoke-Command -Session $this.session -Script {param($PackageIDParam, $VersionIDParam, $UserConfigParam)Set-AppvServerPackage -PackageID $PackageIDParam -DynamicUserConfigurationPath $UserConfigParam -VersionID $VersionIDParam} -ArgumentList $PackageID, $VersionID, $UserConfig
        }
    }

    GrantGroup([string]$Groups, [string]$PackageName)
    {
        Invoke-Command -Session $this.session -Script {param($GroupsParam, $PackageNameParam)Grant-AppvServerPackage -Groups $GroupsParam -Name $PackageNameParam} -ArgumentList $Groups, $PackageName
    }

    RemovePackage([string]$PackageName)
    {
        Invoke-Command -Session $this.session -Script {param($PackageNameParam)Remove-AppvServerPackage -Name $PackageNameParam} -ArgumentList $PackageName
    }

    PublishingPackage([string]$PackageName, [string]$Publishing)
    {
        if($Publishing -eq "1")
        {
            Invoke-Command -Session $this.session -Script {param($PackageNameParam)Publish-AppvServerPackage -Name $PackageNameParam} -ArgumentList $PackageName
        }
        else
        {
            Invoke-Command -Session $this.session -Script {param($PackageNameParam)Unpublish-AppvServerPackage -Name $PackageNameParam} -ArgumentList $PackageName
        }
    }

}
