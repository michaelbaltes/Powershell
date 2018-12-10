function Read-excel ($sheetname, $file) {
        # Object erstellen
        $objExcel = New-Object -ComObject Excel.Application
        $objExcel.Visible = $false
        # Datei anschnallen
        $WorkBook = $objExcel.Workbooks.Open($file)
    
        # welche mappen gibt es?
        $sheet =  ($WorkBook.sheets | Select-Object -Property Name).Name
       
        # Mappe Ã¶ffnen
        $WorkSheet = $WorkBook.Worksheets.Item($sheetname)
    
        # Starte mit Zeile n
        [int]$spalte = 2 # Spalte B
        [int]$zeile = 2 # Zeile 2 enhÃ¤lt Ãœberschrift
        $all = @()
        # $group = New-Object System.Collections.ArrayList
          
            do{
                $object = New-Object psobject 
                $object | Add-Member NoteProperty CloudName ($WorkSheet.Cells.Item($zeile,$spalte).text)
                $object | Add-Member NoteProperty FirstName ($WorkSheet.Cells.Item($zeile,4).text)
                $object | Add-Member NoteProperty LastName ($WorkSheet.Cells.Item($zeile,5).text)
                
                $zeile++ | Out-Null

                $all += $object
            }
            while($WorkSheet.Cells.Item($zeile,$spalte).text.length -gt 0)
            # Write-Warning $zeile
            #COM-Objektes beenden
        $objExcel.Quit()
        #COM-Objektes aus dem Speicher entfernen
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($objExcel)  
    
        return $all
    }

 function get-VSPHInfo ()
        {
          
$SQLServer = "SRV-VSPH-001" #use Server\Instance for named SQL instances!
$SQLDBName = "ODS"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True;" 
#User ID= YourUserID; Password= YourPassword" 
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = 'SELECT * FROM [ODS].[fIT].[Accounts]'
$SqlCmd.Connection = $SqlConnection 
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd 
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) 
$SqlConnection.Close()   

$allVSPH = $DataSet.Tables[0].Rows
return $allVSPH
        }


$allVSPHUser = get-VSPHInfo

$Users = Read-excel -sheetname "Sheet1" -file "C:\_MBA\data\CloudAccounts.xlsx"

foreach ($cloudUser in $users)
    {
     foreach($VUser in $allVSPHUser)
        {
            if($VUser.EmailAddress -like $cloudUser.CloudName)
                {
                Write-Warning -Message "User in VSPH, but not synced via AD: $cloudUser" 
                }
     
     
        }

    }