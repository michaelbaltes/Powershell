

Get-Service | Where-Object CanStop | Out-GridView -Title 'Dienst stoppen' -PassThru | Stop-Service -WhatIf