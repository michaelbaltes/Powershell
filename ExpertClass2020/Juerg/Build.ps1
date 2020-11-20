
$strModuleName = 'EMAdminService'
$strBildDir = "$ENV:Temp\BuildDir\Project-{0}" -f $strModuleName
$strTargetDir = "$strBildDir\{0}" -f $strModuleName
# $strRootModuleName = '{0}.psm1' -f $strModuleName

$null = New-Item -ItemType Directory $strBildDir -force -ErrorAction SilentlyContinue
$null = New-Item -ItemType Directory $strTargetDir -force -ErrorAction SilentlyContinue

# evaluate the most recent version
$colVersions = Get-ChildItem $strTargetDir |
ForEach-Object {[Version]$_.name}
$mostRecentVerion = $colVersions |
Sort-Object -Descending |
Select-Object -first 1

Write-Host "Most recent Version is: $mostRecentVerion"
$strVersion = Read-Host -Prompt "New Version to build"


$strModuleDir = "$strTargetDir\$strVersion"
$strProjectDir = (Get-Item $PSScriptRoot).Parent.FullName
$strSourceDir = "$strProjectDir\{0}" -f $strModuleName



# retrieve the function names to export from all the public ps1 file
$alFunctionsToExport = [System.Collections.ArrayList]::new()
$Public  = @( Get-ChildItem -Path $strSourceDir\Public\*.ps1 -ErrorAction SilentlyContinue )
Foreach($import in $Public) {
    Try {
        
        # Export all functions in this public ps1 file
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($import.fullname,[ref]$null,[ref]$null)
        $colFunctionDefinitions = $ast.FindAll( {$args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]}, $true )
        $colFunctionDefinitions | ForEach-Object {
            $null=$alFunctionsToExport.Add($_.Name)
        }        
    }
    Catch {
        Write-Error -Message "Failed to build the list of functions to export"
    }
}


# build the manifest
. "$PSScriptRoot\CreateManifest.ps1"
$FunctionsToExport = $alFunctionsToExport.ToArray()
$objManifest = New-Manifest -ModuleName $strModuleName -Version $strVersion -FunctionsToExport $FunctionsToExport
Write-Host ("Manifest {0} created." -f $objManifest.fullname)


# Die neue Version bereit stellen
$NULL = New-Item -ItemType Directory "$strTargetDir\$strVersion" -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force -Path "$strSourceDir\*" -Destination $strModuleDir
Write-Host "Module in $strTargetDir erstellt"
