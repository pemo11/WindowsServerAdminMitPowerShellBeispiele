<#
 .Synopsis
 Eine Function arbeitet die komplette Pipeline ab
#>

function Get-Speicherkosten
{
  param([Alias("FullName")]
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)] 
    [String]$Path,
    [Double]$SpeicherkostenMB)

    begin
    {
      $SummeBytes = 0
    }
    
    process
    {
        Get-ChildItem -Path $Path -Directory -Recurse | ForEach-Object {
        Get-ChildItem -Path $_.FullName | ForEach-Object {
            $SummeBytes += $_.Length
            }
        }
        $SpeicherkostenGesamt = [Math]::Round($SummeBytes / 1MB *
          $SpeicherkostenMB, 3)
        [PSCustomObject]@{Pfad=$Path;Kosten=$SpeicherkostenGesamt}
    }
    
    end { }
}

Get-ChildItem -Path $env:USERPROFILE | Get-Speicherkosten -SpeicherkostenMB 0.25