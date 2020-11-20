#Get public and private function definition files.
$Classes  = @( Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

# Import the Class definitions
Foreach ($import in $Classes) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import $($import.fullname): $_"
    }
}

# Dot source the private files
Foreach ($import in $Private) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import $($import.fullname): $_"
    }
}


# Dot source the public files / export the module functions
Foreach ($import in $Public) {
    Try {
        . $import.fullname      
    }
    Catch {
        Write-Error -Message "Failed to import $($import.fullname): $_"
    }
}