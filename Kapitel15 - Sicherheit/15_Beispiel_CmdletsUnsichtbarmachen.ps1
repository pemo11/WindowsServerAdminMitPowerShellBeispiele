<#
 .Synopsis
 Einschränkte Session anlegen, in dem nicht erwünschte Cmdlets unsichtbar gemacht werden
#>

$AllowedCommands = @("Get-ChildItem")
$AllowedCommands += "Get-Content"
$AllowedCommands += "Get-Command"
$AllowedCommands += "Get-Process"
$AllowedCommands += "Get-Service"
$AllowedCommands += "Get-FormatData"
$AllowedCommands += "Select-Object"
$AllowedCommands += "Measure-Object"
$AllowedCommands += "Out-String"
$AllowedCommands += "Out-File"
$AllowedCommands += "Out-Default"
$AllowedCommands += "Exit-PSSession"

# Keine Anwendungen, keine Skripte
$ExecutionContext.SessionState.Applications.Clear()
$ExecutionContext.SessionState.Scripts.Clear()

# Alle nicht erwünschten Cmdlets unsichtbar machen
Get-Command -CommandType Cmdlet | Where-Object { $AllowedCommands -notcontains $_.Name } |  Foreach-Object {
      $_.Visibility = "Private"
}

$ExecutionContext.SessionState.LanguageMode = "RestrictedLanguage"
Write-Warning "Einschränkte Session ist aktiv...
