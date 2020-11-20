#region Init Stopwatch and stuff
Remove-Variable result -ErrorAction SilentlyContinue
$StopWatch = New-Object System.Diagnostics.Stopwatch

function Start-Test($label) {
    Remove-Variable array -ErrorAction SilentlyContinue
    $StopWatch.Restart()
    Clear-Host
    Write-Host $code.toString().Replace('$script:array','$array') -ForegroundColor White 
    & $code

    $perf = $array.Count / $StopWatch.Elapsed.TotalSeconds

    if ((Test-Path -Path variable:result) -eq $false)
    {
        $script:result = $perf
    }
    [PSCustomObject]@{
        TotalSeconds = $StopWatch.Elapsed.TotalSeconds
        ArraySize = $array.Count
        Type = $Label
        Perf = '{0:n0} Elements/s, gain x {1:n1}' -f $perf, ($perf / $result ) 
        }
}

Clear-Host
Write-Host "Good to go! Happy Demoing..."
#endregion

#region Dumb but common...

$code = { 
    $script:array = @()

    for ($x = 1; $x -le 15000; $x++) 
    {
        $script:array += "Line $x"
    }
}

Start-Test -Label 'Dumb (extending an array manually)'

#endregion

#region Smartass but just semi-smart
$code = {
    [System.Collections.ArrayList]$script:array = @()

    for ($x = 1; $x -le 15000; $x++) 
    {
        $null = $array.Add("Line $x")
    }

}
Start-Test -Label 'Semismart (smart-assing with .NET types)'

#endregion

#region Smart

$code = {
    $script:array = for ($x = 1; $x -le 15000; $x++) 
    {
        "Line $x"
    }
}
Start-Test -Label 'Smart (let PS create the array)'

#endregion

#region Smarter (SURPRISE #1)
$code = {
    $script:array = for ($_ = 1; $_ -le 15000; $_++) 
    {
        "Line $_"
    }

}
Start-Test -Label 'Smarter (use internal iteration variable)'

#endregion

#region Pipeline is slowish

$code = {
    $script:array = 1..15000 | ForEach-Object {
        "Line $_"
    }
}
Start-Test -Label 'Pipeline (classic and common use)'
#endregion

#region Speeding up pipeline with reusable functions

$code = {
    function Test
    {
        param([Parameter(ValueFromPipeline)]$Data)

        process
        {
            "Line $Data"
        }
    }

    $script:array = 1..15000 | Test

}
Start-Test -Label 'pipeline-enabled Function (reusable code)'

#endregion

#region Magic with "simple functions" (SURPRISE #2)
$code = {
    $script:array = 1..15000 | & {
        process
        {
            "Line $_"
        }
    }
}
Start-Test -Label 'Magic (using "simple function")'
#endregion

#region Speeding up pipeline with reusable FAST functions
$code = {
    filter Test
    {
        "Line $_"
    }

    $script:array = 1..15000 | Test
}
Start-Test -Label 'pipeline-enabled SIMPLE Function (no attributes used)'

#endregion



#region Streaming for-loop
$code = {
    $script:array = & {for ($_ = 1; $_ -le 15000; $_++) 
        {
            "Line $_"
    } } 
}
Start-Test -Label 'streaming for-loop (if streaming is required)'

#endregion



#region Echo to Grid


function gridOn
{
    Set-Item -Path function:global:Out-Default -Value {

        param(
            [switch]
            $Transcript,

            [Parameter(ValueFromPipeline=$true)]
            [psobject]
            $InputObject
        )

        begin
        {
            $pipeline = { Microsoft.PowerShell.Core\Out-Default @PSBoundParameters }.GetSteppablePipeline($myInvocation.CommandOrigin)
            $pipeline.Begin($PSCmdlet)

            $grid = { Out-GridView -Title 'Results' }.GetSteppablePipeline()
            $grid.Begin($true)
    
        }

        process
        {
            $pipeline.Process($_)
            # do not forward exceptions to the gridview:
            if ($_ -is [System.Management.Automation.ErrorRecord] -eq $false) { $grid.Process($_) }
        }

        end
        {
            $pipeline.End()
            $grid.End()
        }

    }
}
function gridOff { Remove-Item function:Out-Default }

gridOn
#endregion

