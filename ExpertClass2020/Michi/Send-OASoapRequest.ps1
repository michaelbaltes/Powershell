

Function Send-OASoapRequest
{
    <#
            .SYNOPSIS
            Sends a SOAP Request to the specified Uri

            .DESCRIPTION
            Sends a SOAP Request to the specified Uri

            .PARAMETER Uri
            The Uri of the SOAP Endpoint

            .PARAMETER SoapAction
            The method in the contract which should be invoked

            .PARAMETER SoapEnvelope
            The soap envelope which describes the action and parameters

            .PARAMETER Credential
            Optional [PSCredenstial] if it's supported by the endpoint

            .OUTPUTS
            Return value [string] from the web api

            .EXAMPLE
            Send-OASoapRequest -Uri "http://myServer/Foo?tralala" -SoapAction "IvokeCommand" -SoapEnvelope $Envelope
            Send-OASoapRequest -Uri "http://myServer/Foo?tralala" -SoapAction "IvokeCommand" -SoapEnvelope $Envelope -Credential $MyPSCredential

    #>
    param (
        [Parameter(Mandatory)]
        [string]$Uri,
        
        [Parameter(Mandatory)]
        [string]$SoapAction,
        
        [Parameter(Mandatory)]
        [string]$SoapEnvelope,
        
        [PSCredential]$Credential=$null
    )

    $ErrorActionPreference = "Stop"
    $FName = "$($MyInvocation.MyCommand) |"

    Try
    {
        $Headers = @{
            SOAPAction = $SoapAction
            "Accept-Encoding" = "gzip,deflate"
            "Content-Type" = "text/xml;charset=UTF-8"
        }

        # Warning ! You need to encode your SOAP Body / SOAP Envelope to UTF-8
        $Encoding = [System.Text.Encoding]::UTF8
        $SoapEnvelopeEncoded = $Encoding.GetBytes($SoapEnvelope)

        $OALogger.Info("$FName Attempt to send a soap request to: $Uri")
        $OALogger.Debug("$FName   Soap Envelope: $SoapEnvelope")
        if($null -eq $Credential)
        {
            Invoke-RestMethod -UseDefaultCredentials -Uri $Uri -Headers $Headers -Method Post -Body $SoapEnvelopeEncoded -ContentType "application/soap+xml" 
        }
        else
        {
            Invoke-RestMethod -Credential $Credential -Uri $Uri -Headers $Headers -Method Post -Body $SoapEnvelopeEncoded -ContentType "application/xml"
        }

        
        
    }
    catch
    {
        $ex = $_.Exception
        $OALogger.Error("$FName $($ex.Message)")
        $retVal = $null
    }
    finally
    {
        $retVal
    }
 
}