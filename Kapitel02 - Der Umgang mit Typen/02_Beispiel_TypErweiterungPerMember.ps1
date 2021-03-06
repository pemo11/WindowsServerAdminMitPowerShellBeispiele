<#
 .Synopsis
 Typ-Erweiterung über ein Member
#>

Update-TypeData -TypeName System.ServiceProcess.ServiceController `
 -MemberType ScriptProperty `
 -MemberName "AbhDienste" `
 -Value { ($this.DependentServices | Select-Object -ExpandProperty Name) -join "," } -Force

Get-Service | Select-Object Name, AbhDienste
