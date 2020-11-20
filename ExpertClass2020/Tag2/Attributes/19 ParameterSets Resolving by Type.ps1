function Test-This
{
  param
  (
    # Position 0, Type String
    [Parameter(ParameterSetName='by Name',Position=0)]
    [string]
  	$Name,

    # Also Position 0, Type Integer
    [Parameter(ParameterSetName='by Id',Position=0)]
    [int]
  	$Id
  )

  $chosenSet = $PSCmdlet.ParameterSetName

  if ($chosenSet -eq 'by Name')
  {
    "You submitted the name $Name."
  }
  elseif ($chosenSet -eq 'by Id')
  {
    "You submitted a number: $Id"
  }
}

Test-This Tobias
Test-This 12