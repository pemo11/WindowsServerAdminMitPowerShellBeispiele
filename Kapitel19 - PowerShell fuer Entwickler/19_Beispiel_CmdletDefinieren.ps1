<#
 .Synopsis
 Anlegen eines Cmdlets mit dem Namen Get-PoshQuote mit C# und dem Add-Type-Cmdlet
#>

$CmdletDef = Get-Content -Path .\PoshQuoteCmdlet.cs -Raw

Add-Type -TypeDefinition $CmdletDef `
 -Language CSharp -ReferencedAssemblies System.Management.Automation `
 -OutputAssembly PoshQuoteCmdlet.dll -OutputType Library

# Laden der Assmebly per Import-Modul als binäres Modul
Import-Module -Name .\PoshQuoteCmdlet.dll -Verbose
