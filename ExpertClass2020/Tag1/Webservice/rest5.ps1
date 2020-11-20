# https://4bes.nl/2020/08/23/calling-a-rest-api-from-powershell/

$Body = @{
    Cook = "HeikeWilkens"
    Meal = "Pasta"
}
 
$Parameters = @{
    Method = "POST"
    Uri =  "https://4besday4.azurewebsites.net/api/AddMeal"
    Body = ($Body | ConvertTo-Json) 
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters