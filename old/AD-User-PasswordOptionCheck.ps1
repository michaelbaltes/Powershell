$mailto = "michael.baltes@phbern.ch"
$mailfrom = "server@phbern.ch"

# check for student users
$students = get-aduser -filter *  -SearchBase "OU=USR-Studierende,OU=PHBern,DC=intra,DC=phbern,DC=ch" -Properties * | where{$_.PasswordNeverExpires -eq $true -or $_.CannotChangePassword -eq $false} 
if ($students -eq $null)
    {
    Send-MailMessage -To $mailto -from $mailfrom -Subject "PasswordCeck for students no subject found!! - OK" -SmtpServer webmail.phbern.ch
    }
else 
    {
        $logfile = "C:\Scripts\Logs\AD-User-PasswordoptionCheck\student_$(get-date -Format yyyyMMddhh).txt"
        foreach ($user in $students)
        {
        $user | select SamAccountName, userPrincipalName, PasswordNeverExpires, CannotChangePassword | out-file -FilePath $logfile -Append

        # set-ADUser -Identity $user.SamAccountName -CannotChangePassword $True -PasswordNeverExpires $True 
        }
        Send-MailMessage -To $mailto -from $mailfrom -Subject "PasswordCeck for student subject found!! - NOK, please check attached file" -SmtpServer webmail.phbern.ch -Attachments $logfile
    }



$logfile = $null

# Check for staff users
$staff = get-aduser -filter *  -SearchBase "OU=USR-Verwaltung,OU=PHBern,DC=intra,DC=phbern,DC=ch" -Properties * | where{$_.PasswordNeverExpires -eq $true -or $_.CannotChangePassword -eq $true} 
if ($staff -eq $null)
    {
    Send-MailMessage -To $mailto -from $mailfrom -Subject "PasswordCeck for staff no subject found!! - OK" -SmtpServer webmail.phbern.ch
    }
else 
    {
    $logfile = "C:\Scripts\Logs\AD-User-PasswordoptionCheck\staff_$(get-date -Format yyyyMMddhh).txt"
    foreach ($user in $staff)
        {
            $user | select SamAccountName, userPrincipalName, PasswordNeverExpires, CannotChangePassword | out-file -FilePath $logfile -Append
       
            # set-ADUser -Identity $user.SamAccountName -CannotChangePassword $True -PasswordNeverExpires $True 
        }
        Send-MailMessage -To $mailto -from $mailfrom -Subject "PasswordCeck for staff subject found!! - NOK, please check attached file" -SmtpServer webmail.phbern.ch -Attachments $logfile
    }



