function Get-LogFile
{
  param
  (
    
    [ArgumentCompleter({
          # receive information about current state:
          param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
          # check to see whether the user already specified a parent directory...
          if ($fakeBoundParameters.ContainsKey('ParentPath'))
          {
            # if so, take that user input...
            $ParentPath = $fakeBoundParameters['ParentPath']
          }
          else
          {
            # ...else fall back to a default path, i.e. the windows folder
            $ParentPath = $env:windir
          }
    
          # list all log files in the path
          Get-ChildItem -Path $ParentPath -Filter * -ErrorAction Ignore |
          Sort-Object -Property Name |
          # filter results by word to complete
          Where-Object { $_.Name -like "$wordToComplete*" } | 
          Foreach-Object { 
            # create completionresult items:
            $logname = $_.Name
            $fullpath = $_.FullName
            # convert size in bytes to MB:
            $size = '{0:n1} MB' -f ($_.Length/1MB)
            [System.Management.Automation.CompletionResult]::new($fullpath, $logname, "ParameterValue", "$logname`r`n$size")
          }
            })]
    [string]
    $FilePath,
    
    [string]
    $ParentPath = $env:windir
  )

  # return the selected file (or do with it whatever else you'd like, i.e. read it)
  Get-Item -Path $FilePath
}