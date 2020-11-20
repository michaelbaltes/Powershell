$SiteCode = "I01"
$SiteServer = "Z3012SCM111"
$CMClient = $env:COMPUTERNAME

$WmiClassList = Get-WmiObject -List -Namespace root\sms\site_$SiteCode -computername $SiteServer
 $LazyList = @()
 
# Iterate over each WMI class in the namespace
 foreach ($WmiClass in $WmiClassList)
 {
      # Iterate over properties for current WMI class
     foreach ($WmiProperty in $WmiClass.Properties)
     {
         # Iterate over WMI qualifiers for current WMI property
         foreach ($WmiQualifier in $WmiProperty.Qualifiers)
         {
             # If qualifier is named "lazy", and the value is "true", then it's a lazy property
             if ($WmiQualifier.Name -eq 'lazy')
             {
                 # Add class name, property name, and qualifier name to array for processing
                  $LazyList += New-Object PSCustomObject -Property @{ "Class" = $WmiClass.__CLASS; "Property" = $WmiProperty.Name; "Qualifier" = $WmiQualifier.Name }
             }
         }
     }
	
 }
 
# Sort array of lazy properties by WMI class name, property name
 $LazyList = $LazyList | Sort-Object -Property Class,Property
 # Write array of lazy properties to console
  Format-Table -InputObject $LazyList -Property Class,Property,Qualifier #| Out-File "All ConfigMgr Lazy Properties.txt"