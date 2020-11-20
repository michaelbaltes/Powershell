# https://docs.microsoft.com/en-us/sysinternals/downloads/debugview

$WinAPI = @"
    public class WinAPI
    {
    [System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet = System.Runtime.InteropServices.CharSet.Auto)]
    public static extern void OutputDebugString(string message);
    }
"@

Add-Type $WinAPI -Language CSharp

[WinAPI]::OutputDebugString("C# Test")

