#
.Synopsis
Zertifikat anlegen für Schlüsselverschlüsselung und Dokumenteverschlüsselung
.Notes
Setzt das Skript New-SelfSignedCertificateEx.ps1 voraus
#>

. .New-SelfSignedCertificateEx.ps1

$DocSigningEku = "1.3.6.1.4.1.311.80.1"
New-SelfSignedCertificateEx -Subject "CN=DSCCred" -KeyUsage KeyEncipherment  -StoreLocation LocalMachine\My   -EnhancedKeyUsage $DocSigningEku

Get-ChildItem Cert:\CurrentUser\My | Where-Object Subject -eq "CN=DSCCred"