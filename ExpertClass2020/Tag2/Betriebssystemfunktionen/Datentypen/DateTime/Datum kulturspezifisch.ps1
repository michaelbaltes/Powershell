﻿$culture =  [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures') |
  Out-GridView -Title 'Select Culture' -OutputMode Single

