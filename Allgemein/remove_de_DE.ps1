$LangList = Get-WinUserLanguageList
$MarkedLang = $LangList | where LanguageTag -eq "de-DE"
$LangList.Remove($MarkedLang)
Set-WinUserLanguageList $LangList -Force