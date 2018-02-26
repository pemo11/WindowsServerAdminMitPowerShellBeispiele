<#
 .Synopsis
 Eine Typdefinition über den class-Befehl
#>

class Ps1File
{
    [string]$Ps1Path
    [string]$Ps1Name

    Ps1File([string]$Ps1Path)
    {
      $this.Ps1Path = $Ps1Path
      $this.Ps1Name = Split-Path -Path $Ps1Path -Leaf
    }

    [string]Comment()
    {
        return (Get-Content -Path $this.Ps1Path -TotalCount 3) -join "`n"
    }
}

# Mit dem neuen Typ werden Objekte definiert
Get-ChildItem -Path *.ps1 | ForEach-Object {
    $Ps1File = [Ps1File]::new($_.FullName)
    $Ps1File | Select-Object -Property Ps1Name, @{n="Comment";e={$_.Comment() }}
} | Format-List
