$token = $errors = $null

$ast = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\beispiel.ps1",[ref]$token,[ref]$errors)

$ast.FindAll({ $args[0]  -is [System.Management.Automation.Language.VariableExpressionAst]} , $true ) |
  Select-Object -Property VariablePath, StaticType -ExpandProperty Extent
