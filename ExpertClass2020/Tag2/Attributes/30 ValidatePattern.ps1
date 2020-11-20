# allow any text that starts with "Server", followed by 2 to 4 digits:
[ValidatePattern('^Server\d{2,4}$')][string]$ComputerName = 'Server12'

# works:
$ComputerName = 'Server9999'

# fails:
$ComputerName = 'Server2'
$ComputerName = 'Server12345'