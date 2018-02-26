<#
 .Synopsis
 Eine Function mit einem Parameter ohne Pipeline-Bindung
#>

function Get-Speicherkosten
{
  param([Parameter(Mandatory=$true)][String]$Path, [Double]$SpeicherkostenMB)

  $SummeBytes = 0
  Get-ChildItem -Path $Path -Directory -Recurse | ForEach-Object {
    Get-ChildItem -Path $_.FullName -File | ForEach-Object {
        $SummeBytes += $_.Length
    }
  }
  $SpeicherkostenGesamt = [Math]::Round($SummeBytes / 1MB * $SpeicherkostenMB, 3)
  [PSCustomObject]@{Pfad=$Path;Kosten=$SpeicherkostenGesamt}
}

# Aufruf ist nur auf diese Weise möglich
Get-Speicherkosten -Path $env:USERPROFILE\documents -SpeicherkostenMB 0.25