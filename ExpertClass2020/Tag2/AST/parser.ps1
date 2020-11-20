


$ast = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\beispiel.ps1",[ref]$null,[ref]$null)
$ast.FindAll( {$args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]}, $true ) |
  Select-Object -ExpandProperty Name