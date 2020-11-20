function Out-PsoPdf
{
  [CmdletBinding(ConfirmImpact='Medium', SupportsShouldProcess)]
  param
  (
    [String]
    $Path,

    [int]
    $Timeout = 5,

    [switch]
    $Show
  )

  # ask PowerShell whether code should execute:
  $shouldProcess = $PSCmdlet.ShouldProcess($env:COMPUTERNAME, "something insane")

  # turn off automatic confirmation dialogs for all commands
  $ConfirmPreference = 'None'

  # use a condition wherever appropriate to determine whether
  # code should execute:
  if ($shouldProcess)
  {
    New-Item -Path $env:temp\test.txt -Force
    New-Item -Path $env:temp\test.txt -Force
    Write-Host "Executing!" -ForegroundColor Green
  }
  else
  {

    Write-Host "Skipping!" -ForegroundColor Red
  }
}

Out-PsoPdf -Confirm