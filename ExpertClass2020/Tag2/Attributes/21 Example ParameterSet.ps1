function Connect-Server
{
  param
  (
    [Parameter(ParameterSetName='currentUser', Position=0, Mandatory=$false)]
    [Parameter(ParameterSetName='differentUser', Position=0, Mandatory=$true)]
    [string]
    $ComputerName,

    [Parameter(ParameterSetName='differentUser', Position=1, Mandatory=$true)]
    [pscredential]
    $Credential
  )

  $chosenParameterSet = $PSCmdlet.ParameterSetName
  "Parameter Set: $chosenParameterSet"

  switch($chosenParameterSet)
  {
    'currentUser'    { 'User has chosen currentUser' }
    'differentUser'    { 'User has chosen differentUser' }
  }

}

Connect-Server -Credential test