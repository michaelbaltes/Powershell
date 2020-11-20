#requires -runasadmin

$Path = "$env:temp\session2.pssc"
$EndpointName = 'PrintManagementVirtual'
$getUserInfo = @{
  Name='Get-UserInfo'
  ScriptBlock=
  {
    $PSSenderInfo
  }
}

$getUserInfo2 = @{
  Name='Get-UserInfo2'
  ScriptBlock=
  {
    $env:username
  }
}


$testFS = @{
  Name='WriteFile'
  ScriptBlock=
  {
    $env:USERNAME > "$env:windir\test.txt"
  }
}


$getCred = @{
  Name='Get-PrivateCredential'
  ScriptBlock=
  {
    param
    (
      [ValidateSet('IBM','Microsoft','Apple')]
      [Parameter(Mandatory=$true)]
      [String]
      $Customer
    )

    $pwd=@{
      IBM = 'topSecret12'
      Microsoft = 'zumsel1234'
      Apple = 'willibald123'
    }
    
    [System.Management.Automation.PSCredential]::new($Customer, ($pwd[$Customer] | ConvertTo-SecureString -AsPlainText -Force))
  }
}


# Datei anlegen
New-PSSessionConfigurationFile -Path $Path -RunAsVirtualAccount -SessionType RestrictedRemoteServer -LanguageMode NoLanguage -ExecutionPolicy Restricted -FunctionDefinitions $getUserInfo, $getUserInfo2, $getCred, $testFS -VisibleCmdlets get-help #-VisibleProviders FileSystem
# Endpunkt anlegen:
Register-PSSessionConfiguration -Name $EndpointName -Path $Path  <#-ShowSecurityDescriptorUI#> -Force