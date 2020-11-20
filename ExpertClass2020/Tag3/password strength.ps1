# https://powershell.one/powershell-internals/attributes/transformation#handling-securestrings
# download der passworte offline: https://haveibeenpwned.com/Passwords
class SecureStringTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute
{
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData)
    {
        # if a securestring was submitted...
        if ($inputData -is [SecureString])
        {
            # return as-is:
            return $inputData
        }
        # if the argument is a string...
        elseif ($inputData -is [string])
        {
            # convert to secure string:
            return $inputData | ConvertTo-SecureString -AsPlainText -Force
        }
        
        # anything else throws an exception:
        throw [System.InvalidOperationException]::new('Unexpected error.')
    }
}

function Convert-SecureStringToText
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        [SecureString]
        $SecureString
    )
  
    process
    {
        $cred = New-Object -TypeName System.Management.Automation.PSCredential('dummy', $SecureString)
        $cred.GetNetworkCredential().Password
    }

}


[SecureStringTransform()]$kennwort = "geheim"

function Test-PasswordStrength
{
    <#
            .SYNOPSIS
            Short Description
            .DESCRIPTION
            Detailed Description
            .EXAMPLE
            Test-PasswordStrength
            explains how to use the command
            can be multiple lines
            .EXAMPLE
            Test-PasswordStrength
            another example
            can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [SecureString]
        [SecureStringTransform()]
        $Password
    )
  
    $PasswordText = $Password | Convert-SecureStringToText
    [Net.ServicePointManager]::SecurityProtocol = 'Tls12'
    $bytes = [Text.Encoding]::UTF8.GetBytes($PasswordText)
    $stream = [IO.MemoryStream]::new($bytes)
    $hash = Get-FileHash -Algorithm 'SHA1' -InputStream $Stream
    $a,$b = $hash.Hash -split '(?<=^.{5})'
    $result = Invoke-RestMethod -Uri "https://api.pwnedpasswords.com/range/$a" -UseBasicParsing
    $matchedPassword = $result -split  '\r\n' -like "$b*"
    [int]($matchedPassword -split ':')[-1]
  
}

Test-PasswordStrength 