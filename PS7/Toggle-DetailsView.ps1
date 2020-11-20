
function Toggle-DetailsView
{

    $Path1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\DetailsContainer"
    $Path2 = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer'
    $mode = $true
    
    $exists = Test-Path -Path $Path1
    if (!$exists)
    {
        $null = New-Item -Path $Path1
    }
    $values = (Get-ItemProperty -Path $Path1 -Name DetailsContainer ).DetailsContainer
    if ($values.Count -eq 8)
    {
        if ($values[4] -eq 2)
        {
            $values[4] = 1
        }
        else
        {
            $values[4] = 2
            $mode = $false
        }
    }
    else
    {
        $values = 2,0,0,0,1,0,0,0
    }
    
    Set-ItemProperty -Path $Path1 -Name DetailsContainer -Type Binary -Value $values
    if ($mode)
    {
        $exists = Test-Path -Path $Path2
        if (!$exists)
        {
            $null = New-Item -Path $Path2
        }
        Set-ItemProperty -Path $Path2 -Name DetailsContainerSizer -Type Binary -Value 175,1,0,0,1,0,0,0,0,0,0,0,194,3,0,0
    }
    
    Get-CimInstance -ClassName Win32_Process -Filter 'name="explorer.exe"' |
      Where-Object {
          $_ | Invoke-CimMethod -MethodName GetOwner -ErrorAction Ignore |
          Where-Object User -eq $env:username
      } |
      Select-Object -Property @{N='Id';E={$_.ProcessId}} |
      Stop-Process -WhatIf
      #Start-Process -FilePath explorer
    
    return $mode
}

#Stop-Process -name explorer