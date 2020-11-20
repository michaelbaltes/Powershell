function Get-ConnectionString
{
  
  $Path = Join-Path -Path $env:TEMP -ChildPath 'dummy.udl'
  
  $null = New-Item -Path $Path -ItemType File -Force
  
  $CommandArg = """$env:CommonProgramFiles\System\OLE DB\oledb32.dll"",OpenDSLFile "  + $Path 

  
  Start-Process -FilePath Rundll32.exe -Argument $CommandArg -Wait
  $ConnectionString = Get-Content -Path $Path | Select-Object -Last 1
  $ConnectionString | clip.exe
  Write-Warning 'Connection String is also available from clipboard'
  $ConnectionString

} 