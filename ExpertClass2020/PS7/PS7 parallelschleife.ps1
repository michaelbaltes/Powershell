#requires -Version 2.0 -Modules PSOneTools


1..255 | ForEach-Object -Parallel { "10.95.46.$_" ; Start-Sleep -Seconds 2  } -ThrottleLimit 85
