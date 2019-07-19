Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if($env:USERNAME.StartsWith("adm"))

{
#Add-Type -AssemblyName System.Windows.Forms
#Add-Type -AssemblyName System.Drawing
$window = New-Object System.Windows.Forms.Form
$window.Width = 570
$window.Height = 150
$window.ShowIcon = $false
$window.Text = "SCCM Application Creator Starter"
$Label = New-Object System.Windows.Forms.Label
$Label.Location = New-Object System.Drawing.Size(10,10)
$Label.Text = "Geben Sier den hier den kompletten Pfad zur Scriptdatei an. Inkl. Skriptnamen"
$Label.AutoSize = $True
$window.Controls.Add($Label)
$windowTextBox = New-Object System.Windows.Forms.TextBox
$windowTextBox.Location = New-Object System.Drawing.Size(10,30)
$windowTextBox.Size = New-Object System.Drawing.Size(530,500)
$window.Controls.Add($windowTextBox)
 
  $windowButton = New-Object System.Windows.Forms.Button
  $windowButton.Location = New-Object System.Drawing.Size(10,60)
  $windowButton.Size = New-Object System.Drawing.Size(50,50)
  $windowButton.Text = "OK"
  $windowButton.Add_Click({
      if ($windowTextBox.Text.StartsWith('"\\s-prd-ps-001\Sources\Applications')  -and $windowTextBox.Text.Contains("SCCM-Create-Application.ps1"))
         {
         
         $Global:startscript = $windowTextBox.Text.Trim('"')
         
         }
      else
         {
         $ErrorPath = [System.Windows.Forms.MessageBox]::Show("Fehler $([System.Environment]::NewLine)Sie haben den Pfad falsch einegeben!$([System.Environment]::NewLine)" +
         'Geben Sie den Pfad im Format "\\....\.\.ps1" ein!',"",0,[System.Windows.Forms.MessageBoxIcon]::Error)
         $ErrorPath
         }

     $window.Dispose()
     $windowTextBox.Text = $null
  })
 

  $windowButtonCancel = New-Object System.Windows.Forms.Button
  $windowButtonCancel.Location = New-Object System.Drawing.Size(70,60)
  $windowButtonCancel.Size = New-Object System.Drawing.Size(50,50)
  $windowButtonCancel.Text = "Cancel"
  $windowButtonCancel.Add_Click({

   $window.Dispose()
   Exit-PSHostProcess
                           })
$window.Controls.Add($windowButton)
$window.Controls.Add($windowButtonCancel)
[void]$window.ShowDialog()
 
 if($startscript -ne $null)
 {
   #$window.Close()
   $window.Dispose()
 #Start-Process powershell.exe -ArgumentList ("-file $startscript")
 . $startscript

 $startscript = $null
 }

}
else
{

$Result = [System.Windows.Forms.MessageBox]::Show("Achtung $([System.Environment]::NewLine)Sie arbeiten nicht mit einem Adminkonto!$([System.Environment]::NewLine)" +
"Starten Sie das Script neu als adm","",0,[System.Windows.Forms.MessageBoxIcon]::Error)
$Result


}


