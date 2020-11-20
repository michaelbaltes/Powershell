# computername must be a string between 8 and 12 characters:
[ValidateLength(8,12)][string]$computername ='Server2018'

# this works (string is between 8 and 12 char):
$computername = 'Server001'

# this fails (string is too short):
$computername = 'pc1'