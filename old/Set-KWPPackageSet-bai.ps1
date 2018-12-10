Import-Module "E:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager\ConfigurationManager.psd1"
Set-Location BE0:
$apps = $null
$KWP = 'KWPSET{0:00}' 
$deleteallSet = $true


#$appsFromCustomer = @('F5Networks BigIPedgeClient 70.2013 (Full)', `
#'itVOL AVAMdmsMakro 1.0 (Full)', 'GPL EANFontC39hrp36dltt 1.0 (Full)', `
# 'HP ljProM401DrvInstaller 11311 (Full)','lexaktuell lexALV 2016 (Full)')
$appsFromCustomer = Get-Content C:\temp\apps_STA2.txt

$computer = 's32165'


function get-apps($appsFromCustomer)
{
    $appcontrolList = [System.Collections.ArrayList]@()
    foreach($app in $appsFromCustomer)
    {
        if ((Get-CMApplication -name $app | select LocalizedDisplayName)-ne $null)  
        {
        $appcontrolList.Add($app) | Out-Null   
        }
        else
        {
        Write-Warning "Applikation existiert nicht: $app"
        }
          
     }
   return $appcontrolList
}

function Set-Variable($applist)
{
    $counter = 1
    foreach($a in $applist) {

    #$tmp = $KWP -f [int]$i++
    new-CMDeviceVariable -DeviceName $computer -VariableName ($KWP -f [int]$counter++) -VariableValue $a -IsMask 0
    }
}


function get-Variable ()
{
   [array]$kwpexist = Get-CMDeviceVariable -DeviceName $computer | ?{$_.Name -like 'KWPSET*'} | select Value

   #check for exsisting KWPSET
    if ($kwpexist -eq $null)
        {$i = 1
        [System.Collections.ArrayList]$applist = $apps
        
        }
    else
        {$i = $kwpexist.count
        [System.Collections.ArrayList]$applist = $kwpexist.value

            foreach($app in $apps) 
            {
                $applist.Insert($applist.Count,$app)
                
            }

        }
return $applist

}

function delete-KWPSETS()
{

[array]$kwpexist = Get-CMDeviceVariable -DeviceName $computer | ?{$_.Name -like 'KWPSET*'} | select -ExpandProperty Name
foreach($set in $kwpexist)
{
Remove-CMDeviceVariable -DeviceName $computer -VariableName $set -Force
}
}

if($deleteallSet -eq $true)
{
delete-KWPSETS
}
$apps = get-apps -appsFromCustomer $appsFromCustomer
$liste = Get-Variable
Set-Variable -applist $liste


