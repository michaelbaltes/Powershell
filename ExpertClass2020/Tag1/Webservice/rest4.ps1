# https://4bes.nl/2020/08/23/calling-a-rest-api-from-powershell/

$Body = @{
    Cook = "Tobias"
    Meal = "Pasta"
}
 
$Parameters = @{
    Method = "POST"
    Uri =  "https://4besday4.azurewebsites.net/api/AddMeal"
    Body = ($Body | ConvertTo-Json) 
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters -SessionVariable cookie
Invoke-RestMethod "https://4besday4.azurewebsites.net/api/AddMeal" -WebSession $cookie