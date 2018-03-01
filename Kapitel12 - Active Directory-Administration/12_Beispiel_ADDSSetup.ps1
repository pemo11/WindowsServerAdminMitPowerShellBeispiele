<#
 .Synopsis
 Einrichten eines Domaincontrollers
 .Notes
 Install-ADDSForest ist der Nachfolger von dcpromo.exe
 #>

# Zuerst das SafeMode-Adminkennwort anlegen
$PwSec = "demo+123" | ConvertTo-SecureString –AsPlainText –Force

# Aufruf für das Einrichten der ersten Domäne - pskurs.local
Install-ADDSForest ` 
 -SkipPreChecks `
 -DomainName pskurs.local `
 -SafeModeAdministratorPassword $PwSec `
 -DomainMode Win2012R2 `
 -LogPath $env:documents\ADDSInstall.log `
 -Force
