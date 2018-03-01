<#
 .Synopsis
 Debugger-Test
#>

[CmdletBinding()]
param()

function Get-DirectorySize
{
    param([String]$Path)
    (Get-ChildItem -Path $Path -File | Measure-Object -Property Length -Sum).Sum 
    # "$Path wurde erfasst"
}


$Path = "C:\Users\Administrator\Documents"
$TotalSize = 0

Dir -Path $Path -Directory -Recurse | ForEach-Object {
    Write-Verbose "Berechne die Größe von Verzeichnis $($_.FullName)"
    # Hier tritt ein Fehler auf
    $DirectorySize = Get-DirectorySize -Path $_.FullName
    Write-Verbose ("Größe von Verzeichnis {0}: {1}MB" -f $_.FullName, ($DirectorySize / 1MB))
    # Hier wurde ein subtiler Fehler eingebaut
    $TotalSize =+ $DirectorySize
}

[PSCustomObject]@{
  Path=$Path
  TotalSizeMB = [Math]::Round($TotalSize / 1MB, 2)
}

