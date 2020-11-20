# MORE:
# https://powershell.one/powershell-internals/attributes/primer

# create your own class derived from
# System.Management.Automation.ValidateArgumentsAttribute
# by convention, your class name should be suffixed with "Attribute"
# the type name is "ValidatePathExistsAttribute", and the derived attribute
# name will be "ValidatePathExists"
class ValidatePathExistsAttribute : System.Management.Automation.ValidateArgumentsAttribute
{
    [bool]$CreateIfMissing = $false
    [int]$id = 9
    
    # this class must override the method "Validate()"
    # this method MUST USE the signature below. DO NOT change data types
    # $path represents the value assigned by the user:
    [void]Validate([object]$path, [System.Management.Automation.EngineIntrinsics]$engineIntrinsics)
    {
        # perform whatever checks you require.

        # check whether the path is empty:
        if([string]::IsNullOrWhiteSpace($path))
        {
            # whenever something is wrong, throw an exception:
            Throw [System.ArgumentNullException]::new()
        }

        # check whether the path exists:
        if(-not (Test-Path -Path $path))
        {
            # whenever something is wrong, throw an exception:
            if ($this.CreateIfMissing)
            {
                New-Item -Path $Path -ItemType Directory
            }
            else
            {
                Throw [System.IO.FileNotFoundException]::new()
            }
        }

        # if at this point no exception has been thrown, the value is ok
        # and can be assigned.
    }
}


[ValidatePathExists(CreateIfMissing, Id=4)][string]$Path = "c:\gibtesnicht"
