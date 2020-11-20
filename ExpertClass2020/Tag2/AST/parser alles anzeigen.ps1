

$ast = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\beispiel.ps1",[ref]$null,[ref]$null)

$ast.FindAll( {$true}, $true ) |
ForEach-Object {
    $_.GetType().FullName
}
