<#
.Synopsis
    Generates CSV file with KWP version for each Windows 10 KWP client

.DESCRIPTION
    This Script generates a CSV file containing all Windows 10 KWP clients and their KWP version.
    The data is obtained via SQL query on the SCCM database.

.INPUTS
    None

.OUTPUTS
    CSV file with KWP version for each Windows 10 KWP client
    Log file

.NOTES
    Script name:    Get-KWPVersion.ps1
    Author:         Krishanth Rajkumar
    Version:        0.4

    History:        V0.4    22.09.2020  Krishanth Rajkumar      Adjusting filename of csv
                    V0.3    02.09.2020  Krishanth Rajkumar      Setting paths for productive use
                                                                Added script parameters for log handling (default: log to file only)
                    V0.2    19.08.2020  Krishanth Rajkumar      Trying to get KWP version by OS build number (e.g. 10.0.[18363].657 -> 18363 is KWP version 5.0)
                                                                If OS build number is empty, too, KWP version will be shown as "Unknown"
                    V0.1    19.08.2020  Krishanth Rajkumar      Created
                    
#>

#region Parameters
#============================================================================================================================
[CmdletBinding()]
param(
    [switch]$LogToConsole,
    [switch]$NoLogFile
)
#endregion Parameters

#region Functions
#============================================================================================================================
Function Write-Log {
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [ValidateSet('Ok','Info','Warning','Error')]
        [string]$Severity = 'Info'
    )

    if(!$NoLogFile) {
        #write to log file
        $Message = "$(Get-Date -Format G); $Severity; $Message"
        $Message | Out-File -FilePath $script:LOGPATH -Append
    }

    #write to console with color depending on severity
    [string]$Color = ""
    switch ($Severity) {
        'Ok' {$Color = "Green"}
        'Warning' {$Color = "Yellow"}
        'Error' {$Color = "Red"}
        default {$Color = "White"}
    }
    if($LogToConsole) {
        Write-Host -ForegroundColor $Color $Message
    }
}
#endregion Functions

#region Script Variables
#============================================================================================================================
$script:CSVPATH = "SomeDestPath"
$script:LOGPATH = "SomeLogPath"
$script:SQLSERVER = 'SomeServer'
$script:DATABASE = 'SomeDataBase'
$script:SQLQUERY= "SomeQuery"
#endregion Script Variables

#region Main
#============================================================================================================================
Write-Log -Message "----------------------------------------Script started.----------------------------------------"

Write-Log -Message "Trying to retrieve data from data base $script:DATABASE on server $script:SQLSERVER"
try {
    $ConnectionString = "Data Source=$script:SQLSERVER; Integrated Security=SSPI; Initial Catalog=$script:DATABASE"
    $Connection = New-Object system.data.SqlClient.SQLConnection($ConnectionString)
    $Command = New-Object system.data.sqlclient.sqlcommand($script:SQLQUERY, $Connection)
    $Adapter = New-Object System.Data.sqlclient.sqlDataAdapter $Command
    $DataSet = New-Object System.Data.DataSet

    $Connection.Open()
    $Adapter.Fill($DataSet) | Out-Null
    $Connection.Close()

    $SQLData = $DataSet.Tables[0].Rows

    Write-Log -Message "Successfully retrieved data via SQL query" -Severity Ok
}
catch {
    Write-Log -Message "Could not get Data via SQL query" -Severity Error
    Write-Log -Message "Script stopped" -Severity Error
    Exit
}

#array for export
$DataForExport = New-Object -TypeName System.Collections.ArrayList

#dictionary (hashtable) for KWP version via build number
$BuildNumberDictionary = @{
    7601 = "1.6"
    15063 = "3.0.1."
    17134 = "4.0"
    18363 = "5.0"
}

foreach($SQLDataRow in $SQLData) {
    #create hashtable to contain info
    $ClientInfoHash = @{}
    #add info to hashtable
    $ClientInfoHash.Add("ClientName", $SQLDataRow.ClientName)
    
    if([string]::IsNullOrEmpty($SQLDataRow.KWPVersion)) {
        if([string]::IsNullOrEmpty($SQLDataRow.OSBuild)) {
            $ClientInfoHash.Add("KWPVersion", "Unknown")
        }
        else {
            $ClientInfoHash.Add("KWPVersion", $BuildNumberDictionary[[int]$SQLDataRow.OSBuild.Split('.')[2]])
        }
    }
    else {
        $ClientInfoHash.Add("KWPVersion", $SQLDataRow.KWPVersion)
    }

    #convert hashtable to psobject and add to ArrayList for correct csv export
    $DataForExport.Add((New-Object PSObject -Property $ClientInfoHash)) | Out-Null
}

Write-Log -Message "Trying to export data to a csv file"
try{
    #exporting info to csv in select order sorted by ClientName
    $DataForExport | select ClientName, KWPVersion | sort -Property ClientName | Export-Csv -Path $script:CSVPATH -Delimiter ";" -Encoding UTF8 -NoTypeInformation
    Write-Log -Message "Successfully exported csv file" -Severity Ok
}
catch{
    Write-Log -Message "Could not export csv file" -Severity Error
}

Write-Log -Message "End of script reached"
#endregion Main