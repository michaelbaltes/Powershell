Add-Type -assemblyName PresentationFramework
Add-Type -assemblyName PresentationCore
Add-Type -assemblyName WindowsBase

function Find-Type
{
# falls Variable "$script" noch nicht gefüllt ist,
# alle .NET Typen ermitteln:
if (!$script:types)
{
# geladene Assemblys bestimmen:
$assemblies = [AppDomain]::CurrentDomain.GetAssemblies()
# Anzahl für Fortschrittsbalken merken:
$all = $assemblies.Count
$i = 0
# Variable nun füllen
$script:types = $assemblies |
# Fortschrittsbalken anzeigen
ForEach-Object {
$prozent = $i * 100 / $all
Write-Progress -Activity 'Examining assemblies' -Status $_.FullName -PercentComplete $prozent
$i++; $_
} |
ForEach-Object { try { $_.GetExportedTypes() } catch {} } |
Where-Object { $_.isPublic} |
Where-Object { $_.isClass } |
Where-Object { $_.Name -notmatch '(Attribute|Handler|Args|Exception|Collection|Expression)$' }|
Select-Object -ExpandProperty FullName
# Fortschrittsbalken wieder ausblenden:

Write-Progress -Activity 'Examining assemblies' -Completed
}
# Fensterelemente beschaffen:
$window = New-Object Windows.Window
$textBlock = New-Object Windows.Controls.TextBlock
$textBox = New-Object Windows.Controls.TextBox
$listBox = New-Object Windows.Controls.Listbox
$dockPanel = New-Object Windows.Controls.DockPanel
# Fenster konfigurieren:
$window.Width = 500
$window.Height = 300
$window.Title = '.NET Type Finder by Dr. Tobias Weltner'
$window.Content = $dockPanel
$window.Background = 'Orange'
$window.TopMost = $true
# Dockpanel konfigurieren:
$dockPanel.LastChildFill = $true
# Elemente ins Dockpanel aufnehmen:
$dockpanel.AddChild($textBlock)
$dockpanel.AddChild($textBox)
$dockpanel.AddChild($listBox)
# Dockingposition festlegen:
[Windows.Controls.DockPanel]::SetDock($textBlock, 'top')
[Windows.Controls.DockPanel]::SetDock($textbox, 'top')
[Windows.Controls.DockPanel]::SetDock($listbox, 'top')
# TextBlock konfigurieren:
$textBlock.Text = 'Enter part of a .NET type name (i.e. "Dialog"). Multiple keywords are
permitted. Press DOWN to switch to list and select type. Press ENTER to select type. Press ESC to
clear search field. Window will close on ESC if search field is empty.'
$textBlock.TextWrapping = 'Wrap'
$textBlock.Margin = 3
$textBlock.FontFamily = 'Tahoma'
$textblock.Background = 'Orange'
# Textbox konfigurieren:
$textBox.FontFamily = 'Tahoma'
$textBox.FontSize = 26
# wenn der Text in der Textbox sich ändert,
# sofort Liste aktualisieren:
$refreshCode = {
# aktualisiert den Inhalt der Listbox
# die Worte in der Listbox werden gesplittet,
# dann wird daraus ein regulärer Ausdruck erstellt, der nur die Texte
# wählt, in denen ALLE Suchworte gemeinsam vorkommen:
$regex = '^(?=.*?({0})).*$' -f ($textbox.Text.Trim() -split '\s{1,}' -join '))(?=.*?(')
# Inhalt der Listbox sind alle Typen, die dem RegEx entsprechen:
$listBox.ItemsSource = @($types -match $regex)
}
$textBox.add_TextChanged({ & $refreshCode })
# festlegen, was bei Tastendrücken in der Textbox geschehen soll:
$keyDownCode = {
Switch ($args[1].Key)
{
'Return' { & $refreshCode }
'Escape' {
# wenn ESCAPE gedrückt wird und die Textbox leer ist,

# dann Fenster schließen...
if ($textbox.Text -eq '')
{
$window.Close()
}
# ...sonst Textboxinhalt leeren:
else
{
$textBox.Text = ''
}
}
}
}
# wenn in der Textbox DOWN gedrückt wird, den Fokus in die ListBox setzen:
$previewkeyDownCode = {
if ($args[1].Key -eq 'Down')
{
& $refreshCode
$listBox.Focus()
}
}
# Textbox-Ereignishandler binden:
$textBox.add_KeyDown( $keyDownCode )
$textBox.add_PreviewKeyDown( $previewKeyDownCode )
# Textbox soll nach dem Start eingabebereit sein:
$null = $textBox.Focus()
# Listbox konfigurieren:
# wenn in der ListBox UP gedrückt wird und das oberste Element gewählt ist,
# dann den Fokus in die Textbox setzen:
$previewkeyDownCodeListBox = {
if (($args[1].Key -eq 'Up') -and ($listbox.SelectedIndex -lt 1))
{
$listBox.SelectedIndex=-1
$textBox.Focus()
}
}
# festlegen, was bei Tastendrücken in der Listbox geschehen soll:
$keyDownCodeListBox = {
Switch ($args[1].Key)
{
'Return' { $window.Close() }
'Escape' { $textBox.Focus() }
}
}
# Ereignishandler an die Listbox binden:
$listBox.add_previewKeyDown($previewkeyDownCodeListBox)
$listBox.add_KeyDown($keyDownCodeListBox)
# Fenster anzeigen:
$null = $window.ShowDialog()
# ausgewählten Typ zurückgeben
$listBox.SelectedItem
}