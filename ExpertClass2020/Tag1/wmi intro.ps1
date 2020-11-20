

Get-WMIObject -Class Win32_OperatingSystem -ComputerName $env:COMPUTERNAME | Select-Object -Property *Date*


$options = New-CimSessionOption -Protocol Wsman
$session = New-CimSession -ComputerName $env:COMPUTERNAME -SessionOption $options
Get-CimInstance -ClassName Win32_OperatingSystem -CimSession $session | Select-Object -Property *Date*

Remove-CimSession -CimSession $session