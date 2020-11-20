

$job1 = {  Start-Sleep -Seconds 6 ; 1}
$job2 = {  Start-Sleep -Seconds 8 ; 2}
$job3 = {  Start-Sleep -Seconds 5 ; 3}



& $job1
& $job2
& $job3


