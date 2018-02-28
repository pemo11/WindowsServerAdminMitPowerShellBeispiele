

$PwSec = "demo+123" | ConvertTo-SecureString –AsPlainText –Force
Install-ADDSForest `
 -SkipPreChecks `
 -DomainName pskurs.local `
 -SafeModeAdministratorPassword $PwSec `
‘ -DomainMode Win2012R2 `
 -LogPath $env:documents\ADDSInstall.log `
 -Force
