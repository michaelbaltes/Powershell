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

  "Received: $InputData"

}

# user can assign arguments to parameters directly:
Test-This -InputData SomeText

# user can pipe data to function via pipeline:
Get-Process | Test-This