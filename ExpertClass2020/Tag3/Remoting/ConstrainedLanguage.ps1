
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes?view=powershell-7.1

# query endoint capabilities (req admin)
(Get-PSSessionConfiguration -Name Test).LanguageMode

# query local capabilities
$ExecutionContext.SessionState.LanguageMode

# change local capabilities (no return other than restart session!)
<#
FullLanguage:          everything allowed
RestrictedLanguage:    commands only, no scriptblocks, no member access, no variables except most basic ($true, $null, etc), limited operators (-eq, -gt, -lt)
NoLanguage:            API (disabled AddScript(), leaves only AddCommand() and AddParameter()
ConstrainedLanguage:   cmdlets from Windows modules, UMCI-approved cmdlets, all language elements, signed APIs and scripts, more. Details:
                       https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes?view=powershell-7.1

#>
$ExecutionContext.SessionState.LanguageMode = [System.Management.Automation.PSLanguageMode]::ConstrainedLanguage