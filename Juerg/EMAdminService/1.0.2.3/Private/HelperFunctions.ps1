
$strTypeDefinition = @"
using System.Net;
using System.Security.Cryptography.X509Certificates;

public class TrustAllCertsPolicy : ICertificatePolicy
{
    public bool CheckValidationResult( ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem)
    {
        return true;
    }
}
"@

try {
    Add-Type -TypeDefinition $strTypeDefinition -ErrorAction SilentlyContinue
    }
catch {}

[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3, [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12



<#
.SYNOPSIS
    Retrieves the parameters passed to a command
.DESCRIPTION
    Retrieves the parameters passed to a command from the specified parameter set
.EXAMPLE
    PS C:\> Get-ParametersByParametersetName -BoundParameters <parameters> -Command Get-EMDevice -ParameterSetName "Resources"
    
    Returns the list of Parameter Name/Values pairs

.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-ParametersByParametersetName {

    [CmdletBinding()]
    param (
    
        $BoundParameters,
        $CommandName,
        $SetName

    )

    $alResourceParameters = [System.Collections.ArrayList]::new()
    
    $objCommand = Get-Command -Name $CommandName
    
    Foreach ( $kvpParameter in $BoundParameters.GetEnumerator() ) {
        
        $ParameterSetName = $objCommand.Parameters[$kvpParameter.key].Attributes.ParameterSetName
        if ($ParameterSetName -eq $SetName) {
            $null = $alResourceParameters.Add($kvpParameter)
        }

    }

    $alResourceParameters
}


function Invoke-FilterBuilder {

    [CmdletBinding()]
    param (
        $FilterList
    )

    
    $lstFilterPatterns = [System.Collections.Generic.List[string]]::new()

    $objFilterBuilder = [CFilterBuilder]::new()
    foreach ($kvpFilter in $FilterList) {
        
        $strFilterName = $kvpFilter.key
        $strFilterValue = $kvpFilter.value

        $lstFilterPatterns.Add( $objFilterBuilder.GetFilter($strFilterName, $strFilterValue) )
    }

    # concatenate every single filter with an and operator to the resultant filter string
    # endswith(Manufacturer,'Driver - Dell') and Manufacturer eq 'Dell'
    $strFilterOperators = [string]::Join(' and ',$lstFilterPatterns)

    $strFilterOperators

}


function Get-Data {
        
    [CmdletBinding()]
    param (
        
        [string]
        $ServerFQDN,

        [string]
        $EntitySet,
        
        [string]
        $SearchFilter,

        [pscredential]
        $Credential
        
        
    )

    if ( [string]::IsNullOrEmpty($SearchFilter) ) {
        # no search filter specified, return every object of the entity set
        $URL = 'https://{0}/AdminService/wmi/{1}' -f $ServerFQDN, $EntitySet
    }
    else {        
        # a search filter was specified
        $URL = 'https://{0}/AdminService/wmi/{1}?$filter={2}' -f $ServerFQDN, $EntitySet, $SearchFilter
    }

    if ($null -eq $Credential) {
        $Result = Invoke-RestMethod -Method Get -Uri $URL -UseDefaultCredentials
    }
    else {
        $Result = Invoke-RestMethod -Method Get -Uri $URL -Credential $Credential
    }

    $Result.value

}