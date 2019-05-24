 
 # Students
 <#
 foreach ($uCampus in (Get-ADuser -Filter * -Properties * -server srv-dc-007 | where {$_.extensionAttribute2 -eq "student"}))
 {
   Set-ADUser -Identity $uCampus -CannotChangePassword $True -PasswordNeverExpires $True
 }
 #>


 #NMS

foreach ($uCampus in (Get-ADuser -Filter * -Properties * -server srv-dc-007 | where {$_.employeeType -eq "staff" -and $_.UserPrincipalName -like "*nms.phbern.ch"}))
{

 Set-ADUser -Identity $uCampus -CannotChangePassword $True -PasswordNeverExpires $True
 $uCampus.name
}
