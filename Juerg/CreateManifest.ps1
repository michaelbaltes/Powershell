<#
  .SYNOPSIS
    Helper to create/Update the manifest for the module in this directory
  .NOTE
    04.03.2020 Steiger Juerg, RealStuff Informatik AG
    24.07.2020 Steiger Juerg, without any hard coded names
#>

Function New-Manifest {

  param
  (
    [String]
    $ModuleName,

    [Version]
    [Parameter(Mandatory)]
    $Version,

    [Array]
    $FunctionsToExport = @(),

    [String]
    $Author = 'Juerg Steiger',

    [String]
    $Company = 'RealStuff Informatik AG',

    [String]
    $CompyRight = '(c) {0}' -f (Get-Date -format 'yyyy')
  )

  $objManifest = $null
  $strVersion = $Version.ToString()
  $strManifestName = '{0}.psd1' -f $ModuleName 
  $strRootModuleName = '{0}.psm1' -f $ModuleName
  $strManifestFullName = '{0}\..\{1}\{2}' -f $PSScriptRoot, $ModuleName, $strManifestName

  If ( ! (Test-Path (Split-Path -Parent $strManifestFullName))  ) { Throw "Module directory does not exist" }

  Remove-Item $strManifestFullName -ErrorAction SilentlyContinue
  New-ModuleManifest -Path $strManifestFullName `
    -RootModule $strRootModuleName `
    -Author $Author `
    -Copyright $CompyRight `
    -CompanyName $Company `
    -PowerShellVersion 5.0 `
    -ModuleVersion $strVersion `
    -FunctionsToExport $FunctionsToExport `
    -AliasesToExport @() `
    -CmdletsToExport @()

  $objManifest = Get-Item $strManifestFullName -ErrorAction SilentlyContinue
  $objManifest
}
