#Dot-Source all functions
Get-ChildItem -Path $PSScriptRoot\source\*.ps1 |
ForEach-Object {
    . $_.FullName
}

Set-Alias -Name gmxr -Value Get-MxRecord
Set-Alias -Name wmxr -Value Write-MxRecordReport