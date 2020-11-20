function Test-This
{
  # define a default parameter set name in case of
  # ambiguity:
  [CmdletBinding(DefaultParameterSetName='by Name')]
  param
  (
    [Parameter(ParameterSetName='by Name',Position=0)]
    [string]
    $Name,

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

Test-This