function test
{
    <#
        .SYNOPSIS
        My Help
    #>
    [CmdletBinding()]
    param
    (
        [string]
        $Path,

        [SupportsWildcards()]
        [PSDefaultValue(Help = "Jürg")]
        [string]
        $Filter = '*'
    )

}

# parameter "Filter" shows DefaultValue and "Accept wildcard characters" is true
Get-Help test -ShowWindow