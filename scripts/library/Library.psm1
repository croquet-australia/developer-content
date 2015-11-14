Get-ChildItem "$PSScriptRoot" | 
    Where-Object { $_.Name -like "*.ps1"} | 
    ForEach-Object { . $_.FullName }