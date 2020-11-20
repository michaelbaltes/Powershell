

[Regex]::Replace('192.168.1.109', '\d{1,3}$', {param($OldValue) [Int]$OldValue.Value + 1})


[Regex]::Replace('192.168.1.109', '\d{1,3}$', { [Int]$args[0].Value + 1})
