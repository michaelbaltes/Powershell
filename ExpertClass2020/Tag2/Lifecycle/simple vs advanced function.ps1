$PSDefaultParameterValues.Add('Get-*:ComputerName','server12')

function Get-Something
{
    [CmdletBinding()]
    param
    (
        [String]

        $Parameter1,

        [String]
        $ComputerName = ''
    )

    "Computer $ComputerName"
}


function test1 # advanced
{
    param
    (
        [String]
        [Parameter(Mandatory,ValueFromPipeline)]
        $InputObject
    )

    process
    {
        "bearbeite $InputObject"
    }
}

function test2 #simple
{
    process
    {
        "bearbeite $_"
    }
}

filter test3
{
    "bearbeite $_"
}

[System.Diagnostics.Stopwatch]$watch = [System.Diagnostics.Stopwatch]::StartNew()
$a = 1..10000 | test1
$watch.Stop()
$watch.ElapsedMilliseconds
$watch.Restart()
$a = 1..10000 | test2
$watch.Stop()
$watch.ElapsedMilliseconds
$watch.Restart()
$a = 1..10000 | test3
$watch.Stop()
$watch.ElapsedMilliseconds
