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
    [string]
    $InputData
  )

  # place the code into the process block to run it for each
  # incoming pipeline element:
  process
  {
    "Received: $InputData"
  }
}


# user can pipe data to function via pipeline:
Get-Process | Test-This

# fails:
$processes = Get-Process
Test-This -InputData $processes