function Test-This
{
  param
  (
    # this parameter cannot receive data from the pipeline:
    [string]
    $Filter = '*',

    # this parameter CAN receive data from the pipeline,
    # provided it can be converted to string:
    [Parameter(ValueFromPipeline)]
    # you MAY WANT to use a BETTER (more appropriate) input type
    # like System.Diagnostics.Process
    [string[]]
    $InputData
  )

  # place the code into the process block to run it for each
  # incoming pipeline element:
  process
  {
    foreach($_ in $InputData)
    {
        "Received: $_"
    }
  }
}


# user can pipe data to function via pipeline:
Get-Process | Test-This

# fails:
$processes = Get-Process
Test-This -InputData $processes