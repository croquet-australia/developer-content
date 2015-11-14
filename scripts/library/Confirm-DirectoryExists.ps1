Function Confirm-DirectoryExists([string]$Path)
{
    If (!(Test-Path $Path))
    {
        Try
        {
            Write-AzureHost "Creating '$Path' directory..."
            New-Item -Path $Path -ItemType Directory | Out-Null
            # Write-AzureHost "Created '$Path' directory."
        }
        Catch
        {
            Write-AzureHost "Error while creating '$Path' directory."
            throw
        }
    }
}