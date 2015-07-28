<#
	.Author
	Trevor Sullivan <trevor@trevorsullivan.net>

	.Description
	Publishes the PowerShell module to the PowerShell Gallery.

	This PowerShell script is invoked by AppVeyor after the "Deploy" phase has completed successfully.
#>

function Patch-ModuleManifest {
	[CmdletBinding()]
	param (
		[string] $Path
	  , [string] $BuildNumber
	)

	if (!$Path) {
		$Path = Get-ChildItem -Path $env:APPVEYOR_BUILD_FOLDER -Include *.psd1;
		if (!$Path) { throw 'Could not find a module manifest file'; }
	}

	$ManifestContent = Get-Content -Path $Path;
	$ManifestContent = $ManifestContent -replace '(?<=ModuleVersion\s+=\s+'')(?<ModuleVersion>.*)(?='')', ('${{ModuleVersion}}.{0}' -f $BuildNumber);
	Set-Content -Path $Path -Value $ManifestContent;

	$ManifestContent -match '(?<=ModuleVersion\s+=\s+'')(?<ModuleVersion>.*)(?='')';
	Write-Verbose -Message ('Module Version patched: ' + $Matches.ModuleVersion);
}

function Main {
	[CmdletBinding()]
	param ()
	$VerbosePreference = 'continue';

	### Skip the build if the Git tag does not match "release"
	Write-Output -InputObject "Git tag is: $env:APPVEYOR_REPO_TAG_NAME";
	if ($env:APPVEYOR_REPO_TAG_NAME -notmatch 'release') {
#		throw 'The release tag was not found on this commit. Skipping deployment.';
#		return;
	} else {
			Write-Verbose -Message ('The release tag ({0}) was found on this commit. Starting deployment.' -f $env:APPVEYOR_REPO_TAG_NAME);
	}

	'AppVeyor Build Folder: {0}' -f $env:APPVEYOR_BUILD_FOLDER;
	Write-Verbose -Message 'Calling Find-Package command to download nuget-anycpu.exe'
	Find-Package -ForceBootstrap -Name zzzzzz -ErrorAction Ignore;

	Patch-ModuleManifest -Path $env:APPVEYOR_BUILD_FOLDER\PoshNuGet.psm1 -BuildNumber $env:APPVEYOR_BUILD_NUMBER;

	Write-Verbose -Message ('Publishing module {0} to Gallery!' -f $env:APPVEYOR_BUILD_FOLDER);
	Publish-Module -Path $env:APPVEYOR_BUILD_FOLDER -NuGetApiKey $env:psapikey;
	Write-Verbose -Message 'Finished publishing module!'
}

### Invoke Main function
Main;