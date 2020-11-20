

install-module -name psparallel -Scope CurrentUser -Force 
Import-Module psparallel -Verbose


1..40 | Invoke-Parallel -ScriptBlock { "arbeite an $_"; Start-Sleep -Seconds 5 } -ThrottleLimit 20 