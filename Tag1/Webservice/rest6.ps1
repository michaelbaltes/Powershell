# https://www.starwindsoftware.com/blog/consuming-a-restful-api-with-powershell
$username = Read-Host "Enter Ravello username: "
$password = Read-Host "Enter Ravello password: "
$userpass  = $username + ":" + $password
$bytes= [System.Text.Encoding]::UTF8.GetBytes($userpass)
$encodedlogin=[Convert]::ToBase64String($bytes)
$authheader = "Basic " + $encodedlogin
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization",$authheader)
$headers.Add("Accept","application/json")
$headers.Add("Content-Type","application/json")
$uri = "https://cloud.ravellosystems.com/api/v1/login"
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -ContentType "application/json"
$uri = "https://cloud.ravellosystems.com/api/v1/applications"
$response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers