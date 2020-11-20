#requires -Version 1
add-type -type  @'
using System;
using System.Runtime.InteropServices;
using System.ComponentModel;
using System.IO;

namespace Win32Functions
{
  public class ExtendedFileInfo
  {    
    public static long GetFileSizeOnDisk(string file)
    {
        FileInfo info = new FileInfo(file);
        uint dummy, sectorsPerCluster, bytesPerSector;
        int result = GetDiskFreeSpaceW(info.Directory.Root.FullName, out sectorsPerCluster, out bytesPerSector, out dummy, out dummy);
        if (result == 0) throw new Win32Exception();
        uint clusterSize = sectorsPerCluster * bytesPerSector;
        uint hosize;
        uint losize = GetCompressedFileSizeW(file, out hosize);
        long size;
        size = (long)hosize << 32 | losize;
        return ((size + clusterSize - 1) / clusterSize) * clusterSize;
    }

    [DllImport("kernel32.dll")]
    static extern uint GetCompressedFileSizeW([In, MarshalAs(UnmanagedType.LPWStr)] string lpFileName,
       [Out, MarshalAs(UnmanagedType.U4)] out uint lpFileSizeHigh);

    [DllImport("kernel32.dll", SetLastError = true, PreserveSig = true)]
    static extern int GetDiskFreeSpaceW([In, MarshalAs(UnmanagedType.LPWStr)] string lpRootPathName,
       out uint lpSectorsPerCluster, out uint lpBytesPerSector, out uint lpNumberOfFreeClusters,
       out uint lpTotalNumberOfClusters);  
  }
}
'@


Function Get-FolderSize
{
    param
    (
        $Path = $home
    )

    $drive = Split-Path -Path $Path -Qualifier
    $block = (Get-WmiObject -Class Win32_Volume -Filter ('DriveLetter="{0}"' -f $drive)).BlockSize


    $code = {
        ('{0:#,##0.0} MB' -f ($this/1MB)) 
    }
    Get-ChildItem -Path $Path -Directory -Force |
    ForEach-Object -Process {
        Write-Progress -Activity 'Calculating Total Size for:' -Status $_.FullName
        $logicalsum = 0
        $physicalsum = 0
        Get-ChildItem -Path $_.FullName -Recurse -ErrorAction SilentlyContinue -File -Force |
        ForEach-Object {
          $logicalsum += $_.Length
          $physicalsum += [Win32Functions.ExtendedFileInfo]::GetFileSizeOnDisk($_.FullName)
        }
        
        $info = [ordered]@{
          Path = $_.FullName
          LogicalSize = $logicalsum |
          Add-Member -MemberType ScriptMethod -Name toString -Value $code -Force -PassThru
        
          PhysicalSize = $physicalsum |
          Add-Member -MemberType ScriptMethod -Name toString -Value $code -Force -PassThru
        }

        try
        {
        $info.Owner = (Get-Acl $_.FullName).Owner
        }
        catch
        {
        $info.Owner = '[Zugriff verweigert]'
        }
        
        New-Object -TypeName PSObject -Property $info
    }
}

Get-FolderSize -Path $home