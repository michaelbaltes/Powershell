$pc = Get-Content C:\_MBA\data\MAC.txt
foreach ($p in $pc)
{
Get-WmiObject -Class SMS_R_SYSTEM -Namespace "root\sms\site_PHB" -ComputerName srv-sccm-001 | where {$_.name -eq $p} | select name, MACAddresses,IPSubnets | Format-Table -Wrap | out-file C:\_MBA\data\PC-MAC_v2.txt -Append
}