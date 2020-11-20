function New-Shortcut
{
  <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      New-Shortcut
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      New-Shortcut
      another example
      can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory)]
    [ValidatePattern('\.lnk$')]
    [string]
    $ShortcutPath,
    
    [Parameter(Mandatory)]
    [string]
    $TargetPath,
    
    [string]
    $WorkingDirectory='',
   
    [string]
    $IconLocation
  )
  
  if (!$IconLocation)
  {
    $IconLocation = "$TargetPath,0"
  }
  $obj = New-Object -ComObject WScript.Shell
  $scut = $obj.CreateShortcut($ShortcutPath)
  $scut.TargetPath = $TargetPath
  $scut.IconLocation = $IconLocation
  $scut.WorkingDirectory = $WorkingDirectory
  $scut.Save() 
}

