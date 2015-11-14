Function Confirm-JekyllToolsAreInstalled([string] $ToolsDirectory)
{
    # All directories are fully qualified to ensure they can be referenced from any directory
    Confirm-DirectoryExists -Path $ToolsDirectory
    $ToolsDirectory = Resolve-Path -Path $ToolsDirectory

    Write-AzureHost "Confirming Jekyll installation..."

    $initialErrorActionPreference = $ErrorActionPreference
    $initialProgressPreference = $ProgressPreference
    $initialPath = $env:Path

    $ErrorActionPreference = "Stop"

    # Azure's deployment console cannot write to the console
    $ProgressPreference = "SilentlyContinue"

    Try {
        $installersDirectory = "$ToolsDirectory\installers"

        $nuGetUri = "http://www.nuget.org/NuGet.exe"
        $nuGetFile = "$installersDirectory\NuGet.exe"
        $rubyZipUri = "http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.7-i386-mingw32.7z"
        $rubyZipFile = "$installersDirectory\ruby-2.1.7-i386-mingw32.7z"
        $rubyDirectory = "$ToolsDirectory\ruby"
        $rubyDevKitZipUri = "http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"
        $rubyDevKitZipFile = "$installersDirectory\DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"
        $rubyDevKitDirectory = "$ToolsDirectory\ruby-devkit"
        $jekyllFile = "$rubyDirectory\bin\jekyll.bat"
        $7zaFile = "$ToolsDirectory\7ZipCLI\tools\7za.exe"

        $env:Path = "$rubyDirectory\bin;$rubyDevKitDirectory\bin;$initialPath"

        Confirm-DirectoryExists -Path $ToolsDirectory
        Confirm-DirectoryExists -Path $installersDirectory
        Confirm-7ZipIsInstalled
        Confirm-RubyIsInstalled
        Confirm-RubyDevKitIsInstalled
        Confirm-JekyllIsInstalled

        Write-AzureHost "Removing installers..."
        Remove-Item -Path $installersDirectory -Recurse

        Write-AzureHost "Successfully installed Jekyll tools."
    }
    Finally {
        $ErrorActionPreference = $initialErrorActionPreference
        $ProgressPreference = $initialProgressPreference
        $env:Path = $initialPath
    }
}

Function Confirm-7ZipIsInstalled()
{
    If (Test-Path $7zaFile)
    {
        Write-AzureHost "7-Zip CLI is installed."
    }
    Else
    {
        Confirm-DownloadFileExists -Path $nuGetFile -Uri $nuGetUri

        Write-AzureHost "Installing 7-Zip CLI..."
        .$nuGetFile install 7ZipCLI -ExcludeVersion -OutputDirectory $ToolsDirectory
    }
}

Function Confirm-RubyIsInstalled()
{
    If (Test-Path $rubyDirectory)
    {
        Write-AzureHost "Ruby is installed."
    }
    Else
    {
        Confirm-DownloadFileExists -Path $rubyZipFile -Uri $rubyZipUri

        Write-AzureHost "Installing Ruby..."

        Push-Location $ToolsDirectory
        Try {
            .$7zaFile x $rubyZipFile
        }
        Finally {
            Pop-Location
        }
        Move-Item -Path "$ToolsDirectory\ruby-2.1.7-i386-mingw32" -Destination $rubyDirectory
    }
}

Function Confirm-RubyDevKitIsInstalled()
{
    If (Test-Path $rubyDevKitDirectory)
    {
        Write-AzureHost "Ruby DevKit is installed."
    }
    Else
    {
        Confirm-DownloadFileExists -Path $rubyDevKitZipFile -Uri $rubyDevKitZipUri

        Write-AzureHost "Installing Ruby DevKit..."
        New-Item -Path $rubyDevKitDirectory -ItemType Directory | Out-Null

        Push-Location $rubyDevKitDirectory
        Try {
            .$7zaFile x $rubyDevKitZipFile
            
            Write-AzureHost "Binding Ruby DevKit with Ruby..."

            # Creates config.yml template in the current directory
            . ruby.exe dk.rb init

            # Add Ruby's directory
            Add-Content config.yml "- $rubyDirectory`n"

            # Install the DevKit, binding it to your Ruby installation.
            . ruby.exe dk.rb install
        }
        Finally {
            Pop-Location
        }
    }
}

Function Confirm-JekyllIsInstalled()
{
    If (Test-Path $jekyllFile)
    {
        Write-AzureHost "Jekyll is installed."
    }
    Else {
        Try {
            Write-AzureHost "Installing Jekyll gem..."
            . gem install jekyll
            
            Write-AzureHost "Installing wdm gem..."
            . gem install wdm            
        }
        Finally {
            Pop-Location
        }
    }
}