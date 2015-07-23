<#
	.Author
	Trevor Sullivan <trevor@trevorsullivan.net>

	.Description
	Publishes the PowerShell module to the PowerShell Gallery.

	This PowerShell script is invoked by AppVeyor after the "Deploy" phase has completed successfully.
#>

$VerbosePreference = 'continue';
Get-ChildItem -Path env:;
'AppVeyor Build Folder: {0}' -f $env:APPVEYOR_BUILD_FOLDER;
Find-Package -ForceBootstrap -Name z*;
Import-Module -Name c:\repos\PoshNuGet;
Get-Module;
Publish-Module -Name PoshNuGet -NuGetApiKey $env:psapikey;