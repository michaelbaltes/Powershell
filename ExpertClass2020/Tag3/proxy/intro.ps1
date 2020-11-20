

function pipe1
{
    param
    (
        [String]
        [Parameter(Mandatory,ValueFromPipeline)]
        $Eingabe
    )
  
    begin
    {
        Write-Host "Start1"
    }
  
    process
    {
        Write-Host "Schleife1 $_"
        $_
    }
    
    end 
    {
        Write-Host "END1"
    }
  

}

function pipe2
{
    param
    (
        [String]
        [Parameter(Mandatory,ValueFromPipeline)]
        $Eingabe
    )
  
    begin
    {
        Write-Host "Start2"
    }
  
    process
    {
        Write-Host "Schleife2 $_"
        $_
    }
    
    end 
    {
        Write-Host "END2"
    }
  

}

1..10 | pipe1 | pipe2