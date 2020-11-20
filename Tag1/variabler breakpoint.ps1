<#
        dieses Skript aktiviert den Debugger, wenn ID=4 zugewiesen wird
#>

$bp = Set-PSBreakpoint -Variable id -Action { if ($id -eq 4) { break }} -Mode Write -Script $PSCommandPath

try
{
    foreach($_ in (1..1000))
    {
        $id = Get-Random -Minimum 1 -Maximum 10
    
    }


}
finally
{
    Remove-PSBreakpoint -Breakpoint $bp
}