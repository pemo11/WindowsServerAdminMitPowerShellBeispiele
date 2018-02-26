<#
 .Synopsis
 Eine Function mit einem Parameter dieses Mal mit Pipeline-Bindung
#>

function Get-Speicherkosten
{
  param([Alias("FullName")][Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)][String]$Path,
   [Double]$SpeicherkostenMB)

  $SummeBytes = 0
  Get-ChildItem -Path $Path -Directory -Recurse | ForEach-Object {
    Get-ChildItem -Path $_.FullName | ForEach-Object {
        $SummeBytes += $_.Length
        }
  }

  $SpeicherkostenGesamt = [Math]::Round($SummeBytes / 1MB * $SpeicherkostenMB, 3)
  [PSCustomObject]@{Pfad=$Path;Kosten=$SpeicherkostenGesamt}
}

# Der Aufruf ist nun theoretisch auch per Pipeline-Bindung möglich
Get-Item -Path $env:USERPROFILE\documents | Get-Speicherkosten -SpeicherkostenMB 0.25

