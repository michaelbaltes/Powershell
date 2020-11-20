#requires -Version 2.0 -Modules reallysimpledatabase

$Path = "c:\wt\database.db"
$db = Get-Database -Path $Path
Get-ChildItem c:\windows | Import-Database -Database $db -TableName FolderContent
Get-Service | Import-Database -Database $db -TableName Services
Get-ChildItem c:\wt | Import-Database -Database $db -TableName FolderContent

$db.GetTables()
$table = $db.GetTable('Services')
$table.GetFields()
$table.GetData()
$table.GetData('Status=1') | Out-GridView
$db.InvokeSql('Select * From Services') | Out-GridView
$db.InvokeSql('Select DisplayName,ServicesDependedOn,StartType From Services Where Status=1 and Name like "App%" Order By DisplayName Asc') | Out-GridView
dir C:\wt\database.db
$db.Close()
del C:\wt\database.db
