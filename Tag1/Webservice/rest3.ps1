function Get-NumberInfo
{
    param
    (
        [int]
        [Parameter(Mandatory)]
        $Number
    )
    
    $ergebnis = Invoke-RestMethod http://numbersapi.com/$Number  
    "Jetzt kommt der Wert"
    Write-Output "Test"
    Write-Warning 'Warnung'
    Write-Error 'Mist'
    Write-Information 'Info'
    Write-Host 'Host'
    Write-Debug "Debug"
    Write-Verbose 'Verbose'
    return $ergebnis
}


<#
Get-Variable *preference                                   
Get-NumberInfo 55                                          
Get-NumberInfo 55 3>$null                                  
Get-NumberInfo 55 4>$null                                  
$a = Get-NumberInfo 55                                     
$a = Get-NumberInfo 55 4>&1                                
$a = Get-NumberInfo 55 3>&1                                
$a                                                         
$a = Get-NumberInfo 55 3>&1 4>&1 5>&1                      
$a = Get-NumberInfo 55 *>&1                                
$a = Get-NumberInfo 55 3>C:\localdata\warnungen.txt        
get-content C:\localdata\warnungen.txt                     


#>