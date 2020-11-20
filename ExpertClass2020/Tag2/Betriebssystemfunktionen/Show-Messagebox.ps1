function Show-Messagebox
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [String]
        $messageBoxText,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [String]
        $caption,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [Windows.MessageBoxButton]
        $button,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [Windows.MessageBoxImage]
        $icon
        
    )
    
    process
    {
        try
        {
            [System.Windows.MessageBox]::Show($messageBoxText, $caption, $button, $icon)
        }
        catch
        {
            Write-Warning "Error occured: $_"
        }
    }
}