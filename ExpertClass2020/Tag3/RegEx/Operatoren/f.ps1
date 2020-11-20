

1..20 | ForEach-Object { "192.168.2.$_" }

1..20 | ForEach-Object { "exchange$_" }
1..20 | ForEach-Object { 'exchange{0:d5}' -f $_ }
1..20 | ForEach-Object { 'exchange{0:X5}' -f $_ }




