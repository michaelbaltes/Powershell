$c=Add-Type -Name WinAPI -PassThru -MemberDefinition '
[DllImport("user32.dll")] public static extern IntPtr GetShellWindow();
[DllImport("user32.dll")] public static extern int SendMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);'

$dsktp=$c::GetShellWindow()
$WM_COMMAND=273
$accel_F5=New-Object UIntPtr(41504)
$nullptr=[IntPtr]::Zero
[int](($dsktp -eq $nullptr) -or ($c::SendMessageW($dsktp, $WM_COMMAND, $accel_F5, $nullptr) -ne 0))
