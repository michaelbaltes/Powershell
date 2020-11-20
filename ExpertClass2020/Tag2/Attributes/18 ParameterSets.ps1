function Test-This
{
  param
  (
    [Parameter(ParameterSetName='by Name')]
  	$Name,

    [Parameter(ParameterSetName='by Id')]
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

Test-This -Name Tobias
Test-This -Id 12

