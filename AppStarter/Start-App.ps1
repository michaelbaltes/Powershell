Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function mystarter
 {
 param (
 [string]$cmpath,
 [boolean]$okclick
 )

     if($cmpath -ne $null -and $okclick -eq $true)
     {
       $window.Close()
       $window.Dispose()
     
     . $startscript

     $startscript = $null
     }
     else
     {
       $window.Close()
       $window.Dispose()
     }
 }


if($env:USERNAME.StartsWith("adm"))

{
#Add-Type -AssemblyName System.Windows.Forms
#Add-Type -AssemblyName System.Drawing
$global:window = New-Object System.Windows.Forms.Form
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
         
         $startscript = $windowTextBox.Text.Trim('"')
         #$global:startextern = $true
         mystarter -cmpath $startscript -okclick $true
         
         }
      else
         {
         $ErrorPath = [System.Windows.Forms.MessageBox]::Show("Fehler $([System.Environment]::NewLine)Sie haben den Pfad falsch einegeben!$([System.Environment]::NewLine)" +
         'Geben Sie den Pfad im Format "\\....\.\.ps1" ein!',"",0,[System.Windows.Forms.MessageBoxIcon]::Error)
         $ErrorPath
         }

     #$window.Dispose()
     $windowTextBox.Text = $null
  })
 

  $windowButtonCancel = New-Object System.Windows.Forms.Button
  $windowButtonCancel.Location = New-Object System.Drawing.Size(70,60)
  $windowButtonCancel.Size = New-Object System.Drawing.Size(50,50)
  $windowButtonCancel.Text = "Cancel"
  $windowButtonCancel.Add_Click({

   #$window.Dispose()
   #Exit-PSHostProcess
   mystarter -okclick $false
                           })
                           
$window.Controls.Add($windowButton)
$window.Controls.Add($windowButtonCancel)
[void]$window.ShowDialog()
 

 
}
else
{

$Result = [System.Windows.Forms.MessageBox]::Show("Achtung $([System.Environment]::NewLine)Sie arbeiten nicht mit einem Adminkonto!$([System.Environment]::NewLine)" +
"Starten Sie das Script neu als adm","",0,[System.Windows.Forms.MessageBoxIcon]::Error)
$Result


}


