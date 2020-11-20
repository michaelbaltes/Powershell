# snapin dll direkt laden

$Path = Join-Path -Path   "$env:ProgramW6432\IIS\Microsoft Web Deploy V3\" -ChildPath Microsoft.Web.Deployment.PowerShell.dll
Import-Module -Name $Path -Verbose
