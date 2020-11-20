$culture =  [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures') |
  Out-GridView -Title 'Select Culture' -OutputMode Single

 (Get-Date).ToString('dddd', $culture) (Get-Date).ToString('MMMM', $culture)