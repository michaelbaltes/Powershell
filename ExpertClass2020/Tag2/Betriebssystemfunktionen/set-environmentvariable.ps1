
function Set-EnvironmentVariable
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [String]
        $variable,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [AllowEmptyString()]
        [String]
        $value,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [EnvironmentVariableTarget]
        $target
        
    )
    
    process
    {
        try
        {
            [System.Environment]::SetEnvironmentVariable($variable, $value, $target)
        }
        catch
        {
            Write-Warning "Error occured: $_"
        }
    }
}


