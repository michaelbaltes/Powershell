$User = "GitHubUserName"
$Token = "tokenhere"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($User):$($Token)"))
$Header = @{
    Authorization = "Basic $base64AuthInfo"
}