# Eingabe des INTRA Admin Benutzers admxyz@phbern.ch
# **************************************************
$allstudents = get-aduser -filter * -SearchBase "OU=USR-Studierende,OU=PHBern,DC=intra,DC=phbern,DC=ch" | select samaccountname 
$cred = Get-Credential
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://s-prd-exch-001.intra.phbern.ch/powershell/ -Authentication Kerberos -Credential $cred

# Starting Remote Session
Import-PSSession $session

foreach ($student in $allstudents)
{
    if ($(get-remotemailbox -identity $student.samaccountname) -eq $null)
         {
          $student.samaccountname | Out-File -FilePath C:\_MBA\data\Stud_no_email.txt  -Append
         }
   # else {
         #Write-Host "Alles klar mit $($student.samaccountname)"
    #     }
}