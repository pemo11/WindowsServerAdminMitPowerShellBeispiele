<#
 .Synopsis
 Ein Skript in einem eigenen Runspace ausführen und debuggen
#>

$Ps = [PowerShell]::Create()
$Rs = [RunspaceFactory]::CreateRunspace()
$Rs.Name = "RunspaceX"
$Rs.Open()
$Ps.Runspace = $Rs

$Ps1Code = Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath DebugTestScript.ps1) -Raw

[void]$Ps.AddScript($Ps1Code)

$Ps.Invoke()

$Rs.Close()


# Get-Process –Name "PowerShell_ISE" | Enter-PSHost