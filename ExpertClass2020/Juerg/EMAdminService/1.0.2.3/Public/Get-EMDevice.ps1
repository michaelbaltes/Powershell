

Function Get-EMDevice {


    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [string]
        $ServerFQDN,

        [PScredential]
        $Credential,

        # Resources we can query
        [Parameter(ParameterSetName = 'Resources')]
        [String]
        $Name,

        [Parameter(ParameterSetName = 'Resources')]
        [int]
        $ResourceId

    )


    
    $EntitySet = 'SMS_R_System'
    
    $colParameters = $PSCmdlet.MyInvocation.BoundParameters
    $commandName = $PSCmdlet.MyInvocation.InvocationName
    
    $ResourceParameterList = Get-ParametersByParametersetName -BoundParameters $colParameters -CommandName $commandName -SetName 'Resources'
    
    $strFilter = Invoke-FilterBuilder -FilterList $ResourceParameterList
    
    Get-Data -ServerFQDN $ServerFQDN -EntitySet $EntitySet -SearchFilter $strFilter -Credential $Credential

}

