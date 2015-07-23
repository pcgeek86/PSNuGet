<#
	.Author
	Trevor Sullivan <trevor@trevorsullivan.net>

	.Description
	Publishes the PowerShell module to the PowerShell Gallery.

	This PowerShell script is invoked by AppVeyor after the "Deploy" phase has completed successfully.
#>

Find-Package -ForceBootstrap -Name z*;
Import-Module -Name $env:APPVEYOR_BUILD_FOLDER;
Get-Module;
Publish-Module -Name PoshNuGet -NuGetApiKey $env:psapikey;