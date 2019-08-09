$Version = $null
$update = $null
$arUpdate = $null
$datum = Get-Date -Format dd.MM.yyyy

$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()

$historyCount = $Searcher.GetTotalHistoryCount()

# $Searcher.QueryHistory(0, $historyCount) | Select-Object Title, Description, Date, @{name="Operation"; expression={switch($_.operation){1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}}
# $Searcher.QueryHistory(0, $historyCount) | Select-Object Title, Date
$update=  $Searcher.QueryHistory(0, $historyCount) | Where-Object Title -like "Remote Desktop Manager Enterprise*" | select title, Date
if ($update.GetType().BaseType.name -eq "Array")
{
    foreach($i in $update)
        {
            if ((get-date -date $i.date -Format dd.MM.yyyy) -eq $datum)
            {
                $arUpdate = $i.title.Split("Remote Desktop Manager Enterprise")
                $Version = $arUpdate[$arUpdate.LongLength -1]
                write-host $Version
            }

        }
}
else {
    $arUpdate = $update.title.Split("Remote Desktop Manager Enterprise")
    $Version = $arUpdate[$arUpdate.LongLength -1]
    write-host $Version        
}
