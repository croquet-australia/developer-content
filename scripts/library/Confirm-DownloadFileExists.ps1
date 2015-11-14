Function Confirm-DownloadFileExists([string]$Path, [string]$Uri)
{
    # Azure's deployment console cannot write to the console
    $ProgressPreference = "SilentlyContinue"

    If (Test-Path $Path)
    {
        Write-AzureHost "$Path is installed."
    }
    Else
    {
        Write-AzureHost "Downloading $Uri..."
        Invoke-WebRequest -Uri $Uri -OutFile $Path | Out-Null
    }
}
