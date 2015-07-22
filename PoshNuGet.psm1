function New-NuspecFile {
	<#
	.Synopsis
	Creates a new Nuspec file.

	.Parameter PackageId
	The name of the nuspec file that will be created.
	#>
	[CmdletBinding()]
	param ([string] $PackageId)

	$Process = @{
		Wait = $true;
		FilePath = 'nuget.exe';
		ArgumentList = 'spec "{0}"' -f $PackageId;
	}
	Start-Process @Process;
}

function New-NuGetPackage {
    <#
    .Synopsis
    Creates a NuGet package file (.nupkg) from a .nuspec file.

    .Parameter ProjectFile
    The .nuspec, .fsproj, .csproj, or .vbproj file to create the NuGet package from.
    
    .Parameter BasePath
    The filesystem path containing the NuGet package source files.

    .Parameter OutputPath
    The target path where the generated NuGet package will be placed.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo] $ProjectFile
      , [System.IO.DirectoryInfo] $BasePath
      , [System.IO.DirectoryInfo] $OutputPath
    )
    
    $ArgumentList = 'pack "{0}"' -f $ProjectFile;
    $ArgumentList += if ($BasePath) { '-BasePath "{0}"' -f $BasePath } else { };
    $ArgumentList += if ($OutputPath) { '-OutputPath "{0}"' -f $OutputPath } else { };

    $Process = @{
        Wait = $true;
        FilePath = 'nuget.exe';
        ArgumentList = $ArgumentList;
        };
    Start-Process @Process;
}

function Push-NuGetPackage {
    <#
    .Synopsis
    Pushes a NuGet package to a NuGet repository.

    .Parameter FeedUri
    The NuGet feed URI that the package will be pushed to.

    .Parameter ApiKey
    The API key that will be used to authenticate against the NuGet feed.

    .Parameter FilePath
    The path to the NuGet package file (.nupkg) that will be pushed to the NuGet feed.

    .Example
    Push-NuGetPackage -FilePath c:\temp\test.nupkg -FeedUri http://myget.org/f/myfeedname -ApiKey 12345;
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo] $FilePath
      , [Parameter(Mandatory = $true)]
        [System.Uri] $FeedUri
      , [Parameter(Mandatory = $true)]
        [string] $ApiKey
    )

    ### Set up parameters 
    $ArgumentList = 'push "{0}" ' -f $FilePath;
    $ArgumentList += '-ApiKey {0} ' -f $ApiKey;
    $ArgumentList += '-Source "{0}"' -f $FeedUri;

    $Process = @{
        Wait = $true;
        FilePath = $Script:NuGetPath;
        ArgumentList = $ArgumentList;
        };
    Start-Process   
}

function Remove-NuGetPackage {
	<#
	.Synopsis
	Removes a NuGet package from a NuGet feed.
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string] $Name
	  , [Parameter(Mandatory = $true)]
		[string] $Version
	)

	$Process = @{
		Wait = $true;
		FilePath = 'nuget.exe';
		ArgumentList = 'delete "{0}" "{1}"' -f $Name, $Version
	}
}

function Init {
    [CmdletBinding()]
    param ()

    $Script:NuGetPath = "$PSScriptRoot\nuget.exe";

}

Init;