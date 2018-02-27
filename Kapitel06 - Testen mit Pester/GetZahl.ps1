<#
 .Synopsis
 Eine simple Function, die getestet werden soll
#>

function Get-Zahl
{
    param([Int]$Limit=10)
    Get-Random -SetSeed (Get-Date).Millisecond -Maximum $Limit -Minimum 1
}