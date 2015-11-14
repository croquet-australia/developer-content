# Work-around for fact Write-Host does not work with Azure's deployment console.
Function Write-AzureHost([string] $message)
{
    Try
    {        
        $message
    } 
    Catch
    {
        "@echo Error while writing to powershell console."
        throw
    } 
}