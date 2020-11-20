$code = @'
using System;
using System.Collections.Generic;
using System.Management.Automation;

    public class ValidateFileOrFolderExistsAttribute : System.Management.Automation.ValidateArgumentsAttribute
    {
        protected override void Validate(object path, EngineIntrinsics engineEntrinsics)
        {
            if (string.IsNullOrWhiteSpace(path.ToString()))
            {
                throw new ArgumentNullException();
            }
            if(!(System.IO.File.Exists(path.ToString()) || System.IO.Directory.Exists(path.ToString())))
            {
                throw new System.IO.FileNotFoundException();
            }
        }
    }
'@

# compile c# code
Add-Type -TypeDefinition $code

# clean and short new attribute
[ValidateFileOrFolderExists()][string]$Path = "c:\windows"

# works:
$Path = (Get-Process -Id $pid).Path

# fails (does not exist):
$Path = 'e:\doesnotexist.txt'