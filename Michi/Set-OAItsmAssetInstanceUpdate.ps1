<#
.SYNOPSIS
Update computer asset information on ITSM 

.DESCRIPTION
Update computer asset information on ITSM 

.PARAMETER AssetInformation
hashtable with specified asset informations

.PARAMETER NewAssetStatus
string with the specified new asset status 

.OUTPUTS
Returns 0, if the computer asset could be registred successfully

.OUTPUTS
Returns 1, if the computer asset could not be found

.OUTPUTS
Returns 2, if the computer asset registration failed

.EXAMPLE
Set-OAItsmAssetInstanceUpdate -AssetInformation

#>
Function Set-OAItsmAssetInstanceUpdate {
    param (
        #[Parameter(Mandatory=$true,Position=0)]
        #[int32]$AssetId,
        #[Parameter(Mandatory=$true,Position=1)]
        #[int32]$AssetInstanceId,
        [Parameter(Mandatory=$true,Position=0)]
        [Hashtable]$AssetInformation,
        [Parameter(Mandatory=$false,Position=1)]
        [ValidateSet('Received','BeingAssembled','Deployed','InRepair','Down','EndofLife','Transferred','Delete','InInventory','OnLoan','Disposed','Reserved','ReturntoVendor','Ordered')]
        [string]$NewAssetStatus
    )

    try
    {

        $AssetStatus = $null
        if($PSBoundParameters.ContainsKey('NewAssetStatus'))
        {
            $AssetStatus = $NewAssetStatus
        }
        else 
        {
            $AssetStatus = $AssetInformation.AssetStatus
        }
    
        switch ($AssetStatus) {
            "Received" { 
                $AssetInformation.AssetStatus = 1
                break
            }
            "BeingAssembled" { 
                $AssetInformation.AssetStatus = 2
                break
            }
            "Deployed" { 
                $AssetInformation.AssetStatus = 3
                break
            }
            "InRepair" { 
                $AssetInformation.AssetStatus = 4
                break
            }
            "Down" { 
                $AssetInformation.AssetStatus = 5
                break
            }
            "EndofLife" { 
                $AssetInformation.AssetStatus = 6
                break
            }
            "Transferred" { 
                $AssetInformation.AssetStatus = 7
                break
            }
            "Delete" { 
                $AssetInformation.AssetStatus = 8
                break
            }
            "InInventory" { 
                $AssetInformation.AssetStatus = 9
                break
            }
            "OnLoan" { 
                $AssetInformation.AssetStatus = 10
                break
            }
            "Disposed" { 
                $AssetInformation.AssetStatus = 11
                break
            }
            "Reserved" { 
                $AssetInformation.AssetStatus = 12
                break
            }
            "ReturntoVendor" { 
                $AssetInformation.AssetStatus = 13
                break
            }
            "Ordered" { 
                $AssetInformation.AssetStatus = 14
                break
            }
        }

        switch ($AssetInformation.Umgebung) {
            "Integration" { $AssetInformation.Umgebung = 0; break }
            "TestDevelopment" { $AssetInformation.Umgebung = 1; break }
            "Engineering" { $AssetInformation.Umgebung = 2; break }
            "Production" { $AssetInformation.Umgebung = 3; break }
        }

        switch ($AssetInformation.CMW) {
            "CMWRepetitiv" { $AssetInformation.CMW = 0; break }
            "CMWSingular" { $AssetInformation.CMW = 1; break }
            Default { $AssetInformation.CMW = $null }
        }

        switch ($AssetInformation.Persoenlich) {
            "Nein" { $AssetInformation.Persoenlich = 1; break }
            "Ja" { $AssetInformation.Persoenlich = 0; break }
        }

        switch ($AssetInformation.SwdPilot) {
            "Nein" { $AssetInformation.SwdPilot = 1; break }
            "Ja" { $AssetInformation.SwdPilot = 0; break }
        }

        If($null -eq $AssetInformation.floor)
        {
            $AssetInformation.floor = "n.a."
        }

        If($null -eq $AssetInformation.room)
        {
            $AssetInformation.room = "n.a."
        }

        $SoapEnvelope = @"
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:OIZ_J0728:AST:HLCMT_Create_WS">
        <soapenv:Header>
            <urn:AuthenticationInfo>
                <urn:userName>Foo</urn:userName>
                <urn:password>Bar</urn:password>
                <!--Optional:-->
                <urn:authentication>?</urn:authentication>
                <!--Optional:-->
                <urn:locale>?</urn:locale>
                <!--Optional:-->
                <urn:timeZone>?</urn:timeZone>
            </urn:AuthenticationInfo>
        </soapenv:Header>
        <soapenv:Body>
            <urn:HLCMTAssetInstanceUpdate>
                <urn:Status>$($AssetInformation.AssetStatus)</urn:Status>
                <urn:AssetID>$($AssetInformation.AssetID)</urn:AssetID>
                <!--Optional:-->
                <urn:Description>$($AssetInformation.Description)</urn:Description>
                <!--Optional:-->
                <urn:Environment_Specification>$($AssetInformation.Environment_Specification)</urn:Environment_Specification>
                <urn:AuftragID>$($AssetInformation.ITSMReference)</urn:AuftragID>
                <urn:CodeDA>$($AssetInformation.CodeDA)</urn:CodeDA>
                <urn:Standort>$($AssetInformation.Site)</urn:Standort>
                <urn:Etage>$($AssetInformation.floor)</urn:Etage>
                <urn:Buero>$($AssetInformation.room)</urn:Buero>
                <urn:Besitzer>$($AssetInformation.Owner)</urn:Besitzer>
                <!--Optional:-->
                <urn:Benutzer>$($AssetInformation.User)</urn:Benutzer>
                <!--Optional:-->
                <urn:Kostenstelle>$($AssetInformation.CostCenter)</urn:Kostenstelle>
                <!--Optional:-->
                <urn:BudgetCode>$($AssetInformation.Budget_Code)</urn:BudgetCode>
                <!--Optional:-->
                <urn:ClientVersion>$($AssetInformation.ClientVersion)</urn:ClientVersion>
                <!--Optional:-->
                <urn:Umgebung>$($AssetInformation.Umgebung)</urn:Umgebung>
                <!--Optional:-->
                <urn:CMW>$($AssetInformation.CMW)</urn:CMW>
                <!--Optional:-->
                <urn:Lager>$([string]::Empty)</urn:Lager>
                <!--Optional:-->
                <urn:OperatingSystem>$($AssetInformation.OperatingSystem)</urn:OperatingSystem>
                <!--Optional:-->
                <urn:Nutzung>$([string]::Empty)</urn:Nutzung>
                <!--Optional:-->
                <urn:Basisrolle>$($AssetInformation.Basisrolle)</urn:Basisrolle>
                <urn:AssetInstanceID>$($AssetInformation.InstanceId)</urn:AssetInstanceID>
                <!--Optional:-->
                <urn:Persoenlich>$($AssetInformation.Persoenlich)</urn:Persoenlich>
                <!--Optional:-->
                <urn:SwdPilot>$($AssetInformation.SwdPilot)</urn:SwdPilot>
                <!--Optional:-->
                <urn:TicketID></urn:TicketID>
                <!--Optional:-->
                <urn:AssetAssociationType></urn:AssetAssociationType>
            </urn:HLCMTAssetInstanceUpdate>
        </soapenv:Body>
        </soapenv:Envelope>
"@

        $Uri = $OAItsmAssetWebSvcUrl
        $retVal = Send-OASoapRequest -Uri $Uri -SoapAction "urn:OIZ_J0728:AST:HLCMT_Create_WS/HLCMTAssetInstanceUpdate" -SoapEnvelope $SoapEnvelope

    }
    catch
    {
        $ex = $_.Exception;
        $OALogger.Error("$FName Failed to update the asset information:`n$ex")
        Throw "Failed to update the asset information:`n$ex"
    }
    finally
    {
        $true
    }
}