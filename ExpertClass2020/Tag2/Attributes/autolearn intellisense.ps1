# derive from ArgumentTransformationAttribute:
class AutoLearnAttribute : System.Management.Automation.ArgumentTransformationAttribute
{
    # define path to store hint lists
    [string]$Path = "$env:temp\hints"

    # define id to manage multiple hint lists:
    [string]$Id = 'default'

    # define prefix character used to delete the hint list
    [char]$ClearKey = '!'

    # define parameterless constructor:
    AutoLearnAttribute() : base()
    {}

    # define constructor with parameter for id:
    AutoLearnAttribute([string]$Id) : base()
    {
        $this.Id = $Id
    }
    
    # Transform() is called whenever there is a variable or parameter assignment, and returns the value
    # that is actually assigned:
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData)
    {
        # make sure the folder with hints exists
        $exists = Test-Path -Path $this.Path
        if (!$exists) { $null = New-Item -Path $this.Path -ItemType Directory }

        # create filename for hint list
        $filename = '{0}.hint' -f $this.Id
        $hintPath = Join-Path -Path $this.Path -ChildPath $filename
        
        # use a hashtable to keep hint list
        $hints = @{}

        # read hint list if it exists
        $exists = Test-Path -Path $hintPath
        if ($exists) 
        {
            Get-Content -Path $hintPath -Encoding Default |
              # remove leading and trailing blanks
              ForEach-Object { $_.Trim() } |
              # remove empty lines
              Where-Object { ![string]::IsNullOrEmpty($_) } |
              # add to hashtable
              ForEach-Object {
                # value is not used, set it to $true:
                $hints[$_] = $true
              }
        }

        # does the user input start with the clearing key?
        if ($inputData.StartsWith($this.ClearKey))
        {
            # remove the prefix:
            $inputData = $inputData.SubString(1)

            # clear the hint list:
            $hints.Clear()
        }

        # add new value to hint list
        if(![string]::IsNullOrWhiteSpace($inputData))
        {
            $hints[$inputData] = $true
        }
        # save hints list
        $hints.Keys | Sort-Object | Set-Content -Path $hintPath -Encoding Default 
        
        # return the user input (if there was a clearing key at its start,
        # it is now stripped):
        return $inputData
    }
}
class AutoCompleteAttribute : System.Management.Automation.ArgumentCompleterAttribute
{
    # define path to store hint lists
    [string]$Path = "$env:temp\hints"

    # define id to manage multiple hint lists:
    [string]$Id = 'default'
  
    # define parameterless constructor:
    AutoCompleteAttribute() : base([AutoCompleteAttribute]::_createScriptBlock($this)) 
    {}

    # define constructor with parameter for id:
    AutoCompleteAttribute([string]$Id) : base([AutoCompleteAttribute]::_createScriptBlock($this))
    {
        $this.Id = $Id
    }

    # create a static helper method that creates the scriptblock that the base constructor needs
    # this is necessary to be able to access the argument(s) submitted to the constructor
    # the method needs a reference to the object instance to (later) access its optional parameters:
    hidden static [ScriptBlock] _createScriptBlock([AutoCompleteAttribute] $instance)
    {
        $scriptblock = {
            # receive information about current state:
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
   
            # create filename for hint list
            $filename = '{0}.hint' -f $instance.Id
            $hintPath = Join-Path -Path $instance.Path -ChildPath $filename
        
            # use a hashtable to keep hint list
            $hints = @{}

            # read hint list if it exists
            $exists = Test-Path -Path $hintPath
            if ($exists) 
            {
                Get-Content -Path $hintPath -Encoding Default |
                # remove leading and trailing blanks
                ForEach-Object { $_.Trim() } |
                # remove empty lines
                Where-Object { ![string]::IsNullOrEmpty($_) } |
                # filter completion items based on existing text:
                Where-Object { $_.LogName -like "$wordToComplete*" } | 
                # create argument completion results
                Foreach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
            }
        }.GetNewClosure()
        return $scriptblock
    }
}
# attribute [CacheCredential()] transforms strings to creds and caches values:
class CacheCredentialAttribute : System.Management.Automation.ArgumentTransformationAttribute
{
    [string]$Path = "$env:temp\hints"
    [string]$Id = 'default'
    [char]$ClearKey = '!'

    CacheCredentialAttribute() : base()
    {}

    CacheCredentialAttribute([string]$Id) : base()
    {
        $this.Id = $Id
    }
    
    # calculates md5 hash for usernames
    # hashes are used as keys for the serialized hashtable
    # declared as "static" because it has no relation to the attribute instance
    # and is simply a generic helper method:
    static [string] GetHash([string]$UserName)
    {
        $md5 = [System.Security.Cryptography.MD5CryptoServiceProvider]::new()
        $utf8 = [System.Text.UTF8Encoding]::new()
        return [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($UserName.ToLower()))).Replace('-','')
    }

    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData)
    {
        # make sure the folder with hints exists
        $exists = Test-Path -Path $this.Path
        if (!$exists) { $null = New-Item -Path $this.Path -ItemType Directory }

        # create filename for hint list
        $filename = '{0}.xmlhint' -f $this.Id
        $hintPath = Join-Path -Path $this.Path -ChildPath $filename
        
        # use a hashtable to keep hint list
        $hints = @{}

        # read hint list if it exists
        $exists = Test-Path -Path $hintPath
        if ($exists) 
        {
            # hint list is xml data
            # it is a serialized hashtable and can be 
            # deserialized via Import-CliXml if it exists
            # result is a hashtable:
            [System.Collections.Hashtable]$hints = Import-Clixml -Path $hintPath
        }

        # if the argument is a string...
        if ($inputData -is [string])
        {
            # does username start with "!"?
            [bool]$promptAlways = $inputData.StartsWith($this.ClearKey)

            # if not,...
            if (!$promptAlways)
            {
                # get the md5 key for the entered username
                $key = [CacheCredentialAttribute]::GetHash($inputData)
                # ...check to see if the username has been used before,
                # and re-use its credential (no need to enter password again)
                if ($hints.ContainsKey($key))
                {
                    # the hashtable contains username and password, so
                    # create a credential from this:

                    # convert username from securestring to plaintext:
                    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($hints[$key].UserName)
                    $username = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

                    # construct the credential object:
                    $credential = [System.Management.Automation.PSCredential]::new($username, $hints[$key].Password) 
                    return $credential
                }
            }
            else
            {
                # ...else, remove the "!" at the beginning and prompt
                # again for the password (this way, passwords can be updated)
                $inputData = $inputData.SubString(1)
                # delete the cached credentials
                $hints.Clear()
            }
            # ask for a credential:
            $cred = $engineIntrinsics.Host.UI.PromptForCredential("Enter password", "Please enter user account and password", $inputData, "")
            # get the md5 key for the entered username
            $key = [CacheCredentialAttribute]::GetHash($cred.UserName)
            

            # add username and password to the hashtable:
            $hints[$key] = @{
                # save username as securestring to make sure it gets encrypted too:
                UserName = $cred.UserName | ConvertTo-SecureString -AsPlainText -Force
                Password = $cred.Password
            }
            # update the hashtable and write it to file
            # passwords are automatically safely encrypted:
            $hints | Export-Clixml -Path $hintPath
            # return the credential:
            return $cred
        }
        # if a credential was submitted...
        elseif ($inputData -is [PSCredential])
        {
            # get the encrypted key for the entered username
            $key = [CacheCredentialAttribute]::GetHash($inputData.UserName)
            
            # save it to the hashtable:
            $hints[$key] = @{
                UserName = $inputData.UserName | ConvertTo-SecureString -AsPlainText -Force
                Password = $inputData.Password
            }
            # update the hashtable and write it to file:
            $hints | Export-Clixml -Path $hintPath
            # return the credential:
            return $inputData
        }
        throw [System.InvalidOperationException]::new('Unexpected error.')
    }
}


# attribute [SuggestCredential()] suggests cached credentials
class SuggestCredentialAttribute : System.Management.Automation.ArgumentCompleterAttribute
{
    [string]$Path = "$env:temp\hints"
    [string]$Id = 'default'
  
    SuggestCredentialAttribute() : base([SuggestCredentialAttribute]::_createScriptBlock($this)) 
    {}

    SuggestCredentialAttribute([string]$Id) : base([SuggestCredentialAttribute]::_createScriptBlock($this))
    {
        $this.Id = $Id
    }

    hidden static [ScriptBlock] _createScriptBlock([SuggestCredentialAttribute] $instance)
    {
        $scriptblock = {
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
   
            $filename = '{0}.xmlhint' -f $instance.Id
            $hintPath = Join-Path -Path $instance.Path -ChildPath $filename
        
            $exists = Test-Path -Path $hintPath
            if ($exists) 
            {
                # read serialized hint hashtable if it exists...
                [System.Collections.Hashtable]$hints = Import-Clixml -Path $hintPath

                # hint the sorted list of cached user names

                # take the serialized hashtables. We can no longer use the hashtable keys
                # because they are just MD5 hashes:
                $hints.Values |
                ForEach-Object {
                    # decrypt encrypted username
                    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($_.UserName)
                    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
                } |
                Where-Object { $_ } |
                # ...that still match the current user input:
                Where-Object { $_.LogName -like "$wordToComplete*" } | 
                Sort-Object |
                # return completion results:
                Foreach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
            }
        }.GetNewClosure()
        return $scriptblock
    }
}



function Connect-MyServer
{
    param
    (
        [string]
        [Parameter(Mandatory)]
        # auto-learn user names to user.hint
        # and prefix "^" to clear lists
        [AutoLearn('user',ClearKey='^')]
        # auto-complete user names from user.hint
        [AutoComplete('user')]
        $UserName,

        [string]
        [Parameter(Mandatory)]
        # auto-learn computer names to server.hint
        [AutoLearn('server',ClearKey='^')]
        # and prefix "^" to clear lists
        # auto-complete computer names from server.hint
        [AutoComplete('server')]
        $ComputerName
    )

    "hello $Username, connecting you to $ComputerName"
}

# function uses a parameter -Credential that accepts both
# strings (username) and credentials. If the user submits a
# string, a cached credential is returned if available.
# only if there is no cached credential yet, the user gets
# prompted for a password, and the string is transformed
# into a credential.
# when the user prefixes a username with "!", all cached
# credentials are deleted:
function New-Login
{
    param
    (
        [PSCredential]
        [Parameter(Mandatory)]
        # cache credentials to username.xmlhint
        [CacheCredential('usernameSafe')]
        # auto-complete user names from username.xmlhint
        [SuggestCredential('usernameSafe')]
        $Credential
    )

    $username = $Credential.UserName
    Write-Host "hello $username!"
    return $Credential
}