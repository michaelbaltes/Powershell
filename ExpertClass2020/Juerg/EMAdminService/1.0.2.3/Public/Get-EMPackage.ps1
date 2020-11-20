

Function Get-EMPackage {


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
        [string]
        $Manufacturer,

        [Parameter(ParameterSetName = 'Resources')]
        [string]
        $Description,
        
        [Parameter(ParameterSetName = 'Resources')]
        [string]
        $Language,
        
        [Parameter(ParameterSetName = 'Resources')]
        [string]
        $ObjectPath,

        [Parameter(ParameterSetName = 'Resources')]
        [string]
        $PackageID,

        [Parameter(ParameterSetName = 'Resources')]
        [string]
        $Version


    )


    $EntitySet = 'SMS_Package'
    
    $colParameters = $PSCmdlet.MyInvocation.BoundParameters
    $commandName = $PSCmdlet.MyInvocation.InvocationName
    
    $ResourceParameterList = Get-ParametersByParametersetName -BoundParameters $colParameters -CommandName $commandName -SetName 'Resources'
    
    $strFilter = Invoke-FilterBuilder -FilterList $ResourceParameterList
    
    Get-Data -ServerFQDN $ServerFQDN -EntitySet $EntitySet -SearchFilter $strFilter -Credential $Credential

}

