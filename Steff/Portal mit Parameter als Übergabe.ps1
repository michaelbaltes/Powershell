$Tags = @()
$Tags += @{TagName = "CustomerName"; "TagValue" = "SmartIT Services AG - Azure DEV"}
$Tags += @{TagName = "CustomerShort"; "TagValue" = "smdv"}
$Tags += @{TagName = "CustomerProjectNumber"; "TagValue" = "0"}
$Tags += @{TagName = "ServiceOwner"; "TagValue" = "s.beckmann@smartit.ch"}

$Tags = ConvertTo-Json $Tags
$Tags = ConvertFrom-Json $Tags

$OutputTags = @{}
ForEach ($Tag in $Tags)
{
  $OutputTags += @{$Tag.TagName = $Tag.TagValue}
}
$Tags = $OutputTags

$Tags