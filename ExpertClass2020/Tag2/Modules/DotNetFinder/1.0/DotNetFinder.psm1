Get-ChildItem $PSScriptRoot *.ps1 | 
  ForEach-Object {
    . $_.FullName
  }
Export-ModuleMember -Function Find-Enum, Find-TypeByCommandName, Find-TypeByName, Find-Type
