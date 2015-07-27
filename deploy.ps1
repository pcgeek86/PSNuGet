<#
	.Author
	Trevor Sullivan <trevor@trevorsullivan.net>

	.Description
	Publishes the PowerShell module to the PowerShell Gallery.

	This PowerShell script is invoked by AppVeyor after the "Deploy" phase has completed successfully.
#>

$VerbosePreference = 'continue';


### Skip the build if the Git tag does not match "release"
if ($env:APPVEYOR_REPO_TAG_NAME -notmatch 'release') {
	throw 'The release tag was not found on this commit. Skipping deployment.';
	return;
} else {
		Write-Verbose -Message ('The release tag ({0}) was found on this commit. Starting deployment.' -f $env:APPVEYOR_REPO_TAG_NAME);
}

'AppVeyor Build Folder: {0}' -f $env:APPVEYOR_BUILD_FOLDER;
Write-Verbose -Message 'Calling Find-Package command to download nuget-anycpu.exe'
Find-Package -ForceBootstrap -Name zzzzzz -ErrorAction Ignore;

#Import-Module -Name $env:APPVEYOR_BUILD_FOLDER -Force;
#Get-Module;

Write-Verbose -Message ('Publishing module {0} to Gallery!' -f $env:APPVEYOR_BUILD_FOLDER);
Publish-Module -Path $env:APPVEYOR_BUILD_FOLDER -NuGetApiKey $env:psapikey;
Write-Verbose -Message 'Finished publishing module!'