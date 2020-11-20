function Test-PipelineBinding
{
	param
	(
		# receive the entire incoming object
		[Parameter(ValueFromPipeline)]
		$EntireObject,

		# receive the property ID
		[Parameter(ValueFromPipelineByPropertyName)]
		[int]
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