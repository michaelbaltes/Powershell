

function Write-Log
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
		
        [Parameter()]
        [ValidateSet(1, 2, 3)]
        [int]$LogLevel = 1,
        
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    
    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
    $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $LogLevel
    $Line = $Line -f $LineFormat
    Add-Content -Value $Line -Path $Path

}


$Path = "$env:temp\meinlog.log"
Write-Log -Message 'Heureka' -LogLevel 2 -Path $Path
Write-Log -Message '423243423' -LogLevel 3 -Path $Path
Write-Log -Message 'Guten Tach' -LogLevel 1 -Path $Path
Write-Log -Message 'ABC' -LogLevel 3 -Path $Path

Start-Process -FilePath "C:\Users\tobia\OneDrive\Dokumente\Kurse\ExpertClass2020\Tag3\Logging\CMTrace.exe" -ArgumentList $Path