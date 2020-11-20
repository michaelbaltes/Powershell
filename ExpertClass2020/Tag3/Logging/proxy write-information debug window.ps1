


function Write-Information
{
    [CmdletBinding(HelpUri='https://go.microsoft.com/fwlink/?LinkId=525909', RemotingCapability='None')]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [Alias('Msg')]
        [System.Object]
        ${MessageData},

        [Parameter(Position=1)]
        [string[]]
    ${Tags})

    if ($global:proxywindow -eq $null)
    {
        $global:proxywindow = { Out-GridView -Title 'Debug Window' }.GetSteppablePipeline()
        $global:proxywindow.Begin($true)

    }


    $global:proxywindow.Process( "$(Get-Date) $MessageData")

}




Tu-Was

$m = Get-Module abcde
. $m {  $server }