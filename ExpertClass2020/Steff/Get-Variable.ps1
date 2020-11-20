#Get-Variable | Select-Object -Property Name, Options | Where-Object {$_.Options -match 'AllScope' -or $_.Options -match 'ReadOnly' -or $_.Options -match 'Constant'}


Get-Variable | Select-Object -Property Name, Options | 
    Where-Object {
        $_.Options -match 'AllScope' -or $_.Options -match 'ReadOnly' -or $_.Options -match 'Constant'
    }




Get-Variable | Select-Object -Property Name, Options | 
    Where-Object {
        $_.Options -eq [System.Management.Automation.ScopedItemOptions]'ReadOnly,AllScope'
    }
    


Get-Variable | Select-Object -Property Name, Options | 
    Where-Object {
        $_.Options -band [System.Management.Automation.ScopedItemOptions]::ReadOnly
    }

