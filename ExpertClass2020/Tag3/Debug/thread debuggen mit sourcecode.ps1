

$thread = [PowerShell]::Create()
$code = {
    & "C:\Users\tobia\OneDrive\Dokumente\Kurse\ExpertClass2020\Tag3\Debug\payload.ps1"
}
$thread.AddScript($code)
$handle = $thread.BeginInvoke()
