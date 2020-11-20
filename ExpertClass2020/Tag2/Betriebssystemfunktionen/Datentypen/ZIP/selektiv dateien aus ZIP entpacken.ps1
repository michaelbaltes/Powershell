#requires -Version 5.0

$Path = "C:\Users\CCIE\Documents\Test\Test.zip"
$Filter = '*.wav'
$OutPath = 'C:\ZIPFiles'

# ensure the output folder exists
$exists = Test-Path -Path $OutPath
if ($exists -eq $false)
{
  $null = New-Item -Path $OutPath -ItemType Directory -Force
}

# load ZIP methods
Add-Type -AssemblyName System.IO.Compression.FileSystem

# open ZIP archive for reading
$zip = [System.IO.Compression.ZipFile]::OpenRead($Path)

# find all files in ZIP that match the filter (i.e. file extension)
$zip.Entries | 
  Where-Object { $_.FullName -like $Filter } |
  ForEach-Object { 
    # extract the selected items from the ZIP archive
    # and copy them to the out folder
    $FileName = $_.Name
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$OutPath\$FileName", $true)
    }

# close ZIP file
$zip.Dispose()

# open out folder
explorer $OutPath