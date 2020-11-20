$code = Invoke-RestMethod -Uri https://aka.ms/install-powershell.ps1
New-Item -Path function: -Name Install-PowerShell -Value $code -Force
Install-PowerShell -Destination c:\myportablePowershell
Start-Process C:\myportablePowershell\pwsh.exe






Invoke-RestMethod -Uri https://aka.ms/install-powershell.ps1 | Set-ClipBoard






Install-PowerShell -Destination c:\myportablePowershell
C:\myportablePowershell\pwsh.exe
Start-Process C:\myportablePowershell\pwsh.exe

Start-Process shell:AppsFolder