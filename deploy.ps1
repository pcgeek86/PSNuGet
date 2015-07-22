<#
	.Author
	Trevor Sullivan <trevor@trevorsullivan.net>

	.Description
	Publishes the PowerShell module to the PowerShell Gallery.

	This PowerShell script is invoked by AppVeyor after the "Deploy" phase has completed successfully.
#>

Import-Module -Name $PSScriptRoot;

Publish-Module -Name PoshNuGet -ApiKey $env:psapikey;