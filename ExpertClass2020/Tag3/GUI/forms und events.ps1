function test
{
    $text = 'Piep'
    $code = {
        [Console]::Beep()
        Write-Warning $text
    }


    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $Fenster                         = New-Object system.Windows.Forms.Form
    $Fenster.ClientSize              = New-Object System.Drawing.Point(400,400)
    $Fenster.text                    = "AD Tool"
    $Fenster.TopMost                 = $false

    $Button1                         = New-Object system.Windows.Forms.Button
    $Button1.text                    = "Klick Mich"
    $Button1.width                   = 220
    $Button1.height                  = 59
    $Button1.location                = New-Object System.Drawing.Point(163,316)
    $Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

    $Fenster.controls.AddRange(@($Button1))

    $Button1.Add_Click($code.GetNewClosure())
    $fenster
}

$meinFenster = test
$mehrere = test
$meinFenster.ShowDialog()