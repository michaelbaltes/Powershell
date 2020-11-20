

Get-Process -Id $pid |
  ForEach-Object -begin { $hash = [Ordered]@{} } -process { 
      foreach($prop in $_.PSObject.Properties)
      {
        $hash[$Prop.Name] = $prop.Value
      
      }
  
  } -end { $Hash } | 
  Out-GridView