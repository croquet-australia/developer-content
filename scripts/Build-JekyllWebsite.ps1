param([string] $RepositoryDirectory, [string] $ToolsDirectory)

Function Main([string] $RepositoryDirectory, [string] $ToolsDirectory)
{

    Write-AzureHost "Build Jekyll Website..."
    Write-AzureHost "Current location is $(Get-Location)."

    $initialErrorActionPreference = $ErrorActionPreference
    $initialProgressPreference = $ProgressPreference
    $initialPath = $env:Path
    $initialLocation = Get-Location

    $ErrorActionPreference = "Stop"

    # Azure's deployment console cannot write to the console
    $ProgressPreference = "SilentlyContinue"
    
    Try {

        Confirm-JekyllToolsAreInstalled -ToolsDirectory $ToolsDirectory

        # All directories are fully qualified to ensure they can be referenced from any directory
        # 
        # Directories must be resolve after confirm Jekyll tools have been installed otherwise
        # Resolve-Path will fail if $ToolsDirectory does not exist yet.
        Set-Location $initialLocation
        $RepositoryDirectory = Resolve-Path -Path $RepositoryDirectory
        $ToolsDirectory = Resolve-Path -Path $ToolsDirectory

        Write-AzureHost "Changing location to $RepositoryDirectory\source..."
        Set-Location $RepositoryDirectory\source

        Write-AzureHost "Adding Ruby '$ToolsDirectory\ruby\bin' to path..."
        $env:Path = "$ToolsDirectory\ruby\bin;$env:Path"

        Write-AzureHost "Calling jekyll build..."
        . cmd.exe /c "call jekyll build"

        if ($lastexitcode -ne 0) {
            throw "jekyll build failed."
        }

        Write-AzureHost "Successfully built Jekyll website."
    }
    Catch {
        Write-AzureHost $_
        
        If ($initialLocation -ne 0) {
            exit $lastexitcode            
        }
        exit 1
    }
    Finally {
        $ErrorActionPreference = $initialErrorActionPreference
        $ProgressPreference = $initialProgressPreference
        $env:Path = $initialPath

        Set-Location $initialLocation
    }
}

Import-Module $PSScriptRoot\library\Library.psm1 -Force -ErrorAction Stop
Main -RepositoryDirectory $RepositoryDirectory -ToolsDirectory $ToolsDirectory
