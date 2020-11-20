function Get-EventLogEntry
{
    # https://powershell.one/powershell-internals/attributes/auto-completion#responding-to-other-arguments
    param
    (
        # suggest today, yesterday, and last week:
        [ArgumentCompleter({
                    # receive information about current state:
                    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    
                    # list all eventlog names...
                    Get-WinEvent -ListLog * -ErrorAction Ignore | 
                    # ...that have records...
                    Where-Object RecordCount -gt 0 | 
                    Sort-Object -Property LogName |
                    # filter results by word to complete
                    Where-Object { $_.LogName -like "*$wordToComplete*" } | 
                    Foreach-Object { 
                        # create completionresult items:
                        $logname = $_.LogName
                        $records = $_.RecordCount
                        if ($logname -like '* *')
                        {
                            $LogNameQuoted = "'$Logname'"
                        }
                        else
                        {
                            $LogNameQuoted = $logname
                        }
                        [System.Management.Automation.CompletionResult]::new($lognameQuoted, $logname, [System.Management.Automation.CompletionResultType]::History , "$logname`r`n$records records available")
                    }
            })]
        [string]
        $LogName,
    
        [int]
        $MaxEvents
    )

    # forward (splatting) the user parameters to this command (must be same name):
    Get-WinEvent @PSBoundParameters
}