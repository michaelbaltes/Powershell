function Test-PipelineBinding
{
	param
	(
		# receive the entire incoming object
		[Parameter(ValueFromPipeline)]
		$EntireObject,

		# receive the property ID
		[Parameter(ValueFromPipelineByPropertyName)]
		[int64]
		# add two more names for this parameter:
		[Alias('Length','ifIndex')]
		$Id,

		# receive the property Name
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]
		$Name
	)

	process
	{
		# emit all received properties
		$PSBoundParameters
	}

}

# pipe suitable objects into the function:
Get-Process | Test-PipelineBinding
# thanks to the aliases, your function is compatible to a
# wide range of data (even if it does not make much sense
# in this demo)
dir c:\windows | Test-PipelineBinding
Get-NetAdapter | Test-PipelineBinding