<#
.SYNOPSIS
Converts a json object to a hashtable

.DESCRIPTION
Converts a json object to a hashtable

.PARAMETER InputObject
The object (json) which should be converted to a ordered hashtable

.OUTPUTS
Returns a [hashtable] object

.EXAMPLE
ConvertTo-OAHashtable -InputObject $MyJson

#>
function ConvertTo-OAHashtable {
    [CmdletBinding()]
    [OutputType('hashtable')]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    
    try
    {
        $FName = "$($MyInvocation.MyCommand) |"
    
        $hash = [ordered]@{}
        $InutObject = [PSCustomObject]$InputObject
        if ($InputObject -is [PSCustomObject])  
        {
            foreach ($property in $InputObject.PSObject.Properties) {
                if($property.Value -is [System.Management.Automation.PSCustomObject])
                {
                    $propertyValue = ConvertTo-OAHashtable -InputObject $property.Value

                    $OALogger.Trace("$FName Attempt to add property to hashtable")
                    $OALogger.Trace("$FName   Property Name: $($property.Name)")
                    $OALogger.Trace("$FName   Property Value: $propertyValue")
                    $hash.Add($property.Name,$propertyValue)
                }
                else
                {
                    $OALogger.Trace("$FName Attempt to add property to hashtable")
                    $OALogger.Trace("$FName   Property Name: $($property.Name)")
                    $OALogger.Trace("$FName   Property Value: $($property.Value)")
                    if(![string]::IsNullOrEmpty("$($property.Name)"))
                    {
                        $hash.Add($property.Name,$property.Value)
                    }
                    else
                    {
                        $OALogger.Warn("$FName   Empty Property Name")
                    }
                }
            }
        }
        elseif($InputObject -is [System.Collections.IEnumerable])
        {
            foreach ($property in $InputObject.GetEnumerator()) {
                if($property.Value -is [System.Management.Automation.PSCustomObject])
                {
                    $propertyValue = ConvertTo-OAHashtable -InputObject $property.Value

                    $OALogger.Trace("$FName Attempt to add property to hashtable")
                    $OALogger.Trace("$FName   Property Name: $($property.Name)")
                    $OALogger.Trace("$FName   Property Value: $propertyValue")
                    $hash.Add($property.Name,$propertyValue)

                }
                else
                {
                    $OALogger.Trace("$FName Attempt to add property to hashtable")
                    $OALogger.Trace("$FName   Property Name: $($property.Name)")
                    $OALogger.Trace("$FName   Property Value: $($property.Value)")
                    if(![string]::IsNullOrEmpty("$($property.Name)"))
                    {
                        $hash.Add($property.Name,$property.Value)
                    }
                    else
                    {
                        $OALogger.Warn("$FName   Empty Property Name")
                    }
                }
            }
        }
    }
    catch
    {
        $ex = $_.Exception;
        $OALogger.Error("$FName Failed to convert json object:`n$ex")
        Throw "$FName Failed to convert json object: $($ex.Message)"
    }
    finally
    {
        $hash
    }
}