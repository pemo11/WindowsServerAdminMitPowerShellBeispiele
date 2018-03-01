<#
.Synopsis
Beispiel für einen bedingten Haltepunkt
#>

$Ps1Pfad = Join-Path -Path $PSScriptRoot -ChildPath Zaehlskript.ps1

$SBAction = {
   if ($i -eq 5) { break }
}

# Haltepunkt setzen und mit einer Bedingung verknüpfen
Set-PSBreakPoint -Script $Ps1Pfad -Variable i -Action $SBAction
.$Ps1Pfad

f1 -Max 10

# Den Haltepunkt wieder löschen
Get-PSBreakpoint | Remove-PSBreakpoint 