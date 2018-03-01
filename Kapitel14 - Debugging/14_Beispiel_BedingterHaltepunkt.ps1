<#
.Synopsis
Beispiel für einen bedingten Haltepunkt
#>

$Ps1Pfad = Join-Path -Path $PSScriptRoot -ChildPath Zaehlskript.ps1

$SBAction = {
   if ($i -eq 5) { break }
}

Set-PSBreakPoint -Script $Ps1Pfad -Variable i -Action $SBAction
.$Ps1Pfad

f1 -Max 10