# - Script to remove duplicate computer entries in WSUS
#
# - Created by Fabio Calcio-Gandino / Unisys & Michael Baltes PH Bern
#
# - Version 1.0
#
#################################################################################################################
#
# Check previously run
if (Test-Path -Path HKLM:\SYSTEM\PHB){
    
      Write-EventLog -LogName Application -Source "PHB-WSUS-Cleanup" -Message "Script already runs." -EventId 1
      }
  else{
          # Stop WSUS Service
          Stop-Service -Name wuauserv -Force 
          #
          # Delete Registry Keys
          Do {
            Write-warning -Message "Windows Update Service not stopped to delete regkeys."
            #Start-Sleep -Seconds 1
            $status = (Get-Service -Name wuauserv)
            } While ($status.status -ne "Stopped")
               
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "PingID"
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "AccountDomainSid"
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "SusClientId"
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "SusClientIDValidation"
             
          #
          # Start WSUS Service
          Start-Service -Name wuauserv
          #
          # Register Computer in WSUS
          #
          # wuauclt.exe /resetauthorization /detectnow
          #
          Do {
              Write-warning -Message "Windows Update Service not running to run detect now."
              Start-Sleep -Seconds 1
              } #End Do
          While ((Get-Service -Name wuauserv).Status -ne "Running")
          {
            Start-Process -FilePath "C:\Windows\System32\wuauclt.exe" -ArgumentList "-resetauthorization -detectnow"
          }
          #
          # Write Registry Status for WSUS Reset
          #
          New-Item -Path "HKLM:\SYSTEM\" -Name "PHB"
          Set-ItemProperty -Path "HKLM:\SYSTEM\PHB\" -Name "WSUSReset" -Value "done"
          #
          # Create new EventLog entry fpr later run.
          New-EventLog -LogName Application -Source "PHB-WSUS-Cleanup"    
  }
  #
  # End
  