800..10000 | ForEach-Object {
        Start-Sleep -Seconds 1
        [Console]::Beep($_, 500)
        $_
    }