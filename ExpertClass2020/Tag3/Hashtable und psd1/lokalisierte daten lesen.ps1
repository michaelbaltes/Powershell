
# [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures') | Out-GridView
Import-LocalizedData -FileName data.psd1 -BindingVariable infos -BaseDirectory Z:\Tag2\PSD1 <#-UICulture en-us#>
$infos 