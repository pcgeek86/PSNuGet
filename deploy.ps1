<#
	.Author
	Trevor Sullivan <trevor@trevorsullivan.net>

	.Description
	Publishes the PowerShell module to the PowerShell Gallery.

	This PowerShell script is invoked by AppVeyor after the "Deploy" phase has completed successfully.
#>

$VerbosePreference = 'continue';
'AppVeyor Build Folder: {0}' -f $env:APPVEYOR_BUILD_FOLDER;
Write-Verbose -Message 'Calling Find-Package command to download nuget-anycpu.exe'
Find-Package -ForceBootstrap -Name zzzzzz;

#Import-Module -Name $env:APPVEYOR_BUILD_FOLDER -Force;
#Get-Module;

Write-Verbose -Message ('Publishing module {0} to Gallery!' -f $env:APPVEYOR_BUILD_FOLDER);
Publish-Module -Path $env:APPVEYOR_BUILD_FOLDER -NuGetApiKey $env:psapikey;
Write-Verbose -Message 'Finished publishing module!'