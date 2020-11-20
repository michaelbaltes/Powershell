function Test-ParamArray
{
    param
    (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Text,
        
        [string]
        $Nochwas
    )

    $text
    "Nochwas: $Nochwas"
}

Test-ParamArray dies ist ein kleines beispiel