


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


    Write-Host "$(Get-Date) $MessageData" -ForegroundColor Red

}




Tu-Was

$m = Get-Module abcde
. $m {  $server }