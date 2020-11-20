
[Environment]::GetLogicalDrives()
$vorher = [Environment]::TickCount
Start-Sleep -Seconds 2
$nachher = [Environment]::TickCount
$nachher - $vorher

[Environment]::GetCommandLineArgs()


[System.IO.Path]::ChangeExtension("c:\test.txt", ".sik")
[System.IO.Path]::GetFileNameWithoutExtension('c:\test.txt')

# usa:
[DateTime]'1.10.2000'
# eigene region:
'1.10.2000' -as [DateTime]






