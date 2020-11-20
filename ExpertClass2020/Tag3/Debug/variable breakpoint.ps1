

for ($x = 1000; $x -lt 15000; $x += 300) 
{
  "Frequency $x Hz"
  [Console]::Beep($x, 500)
}
