function Out-Speech
{
  param
  (
    # require a text no longer than 200 characters
    # and no shorter than 1 characters
    [Parameter(Mandatory)]
    [ValidateLength(1,200)]
    [string]
    $Text,

    # require a number between -10 and 10
    [ValidateRange(-10,10)]
    [int]
    $Speed = 0
  )

  $sapi = New-Object -ComObject Sapi.SpVoice
  $sapi.Rate = $Speed
  $null = $sapi.Speak($Text)
}


# works:
Out-Speech -Text 'Hello World!' -Speed 3
Out-Speech -Text 'I am afraid I am drunk.' -Speed -10

# fails (speed to small):
Out-Speech -Text 'Hello World!' -Speed -20