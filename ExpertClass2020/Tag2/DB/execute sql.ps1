
$InstanceId = "$env:computername\FIRSTDB"
$Database = "master"
$connectionString = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=$Database;Data Source=$InstanceId"
$sql = "select * from sys.databases"

$connection = New-Object -ComObject ADODB.Connection
$connection.Open($connectionString)
$rs = $connection.Execute($sql)

while ($rs.Eof -eq $false)
{
  $hash = @{}
  foreach($field in $rs.Fields)
  {
    $hash[$field.Name] = $field.Value
  }
  [PSCustomObject]$hash

  $rs.MoveNext()
}

$rs.Close()
$connection.Close()

