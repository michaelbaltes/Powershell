function Out-TobSpeaker
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Out-TobSpeaker
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Out-TobSpeaker
        another example
        can have as many examples as you like
    #>
    param
    (
        
        [int]
        $Rate = 0,
        
        [Parameter(Mandatory)]
        [string]
        $Text
    )
    
    $sapi = New-Object -ComObject Sapi.SpVoice
    $sapi.Rate = $Rate
    $sapi.Speak($Text)
}

