<#
 .Synopsis
 Texte verschlüsseln mit der CipherLite-Bibliothel
 .Notes
 Setzt CipherLite.dll voraus
 Download von http://www.obviex.com/CipherLite/Downloads.aspx
#>


# Pfad existiert nach der Installation des Msi-Pakets
$DllPath = "C:\Program Files\CipherLite.NET\CipherLite.dll"
Add-Type -Path $DllPath -PassThru

$CyPw = "abcdefg"
$Pw = "geheim+123"
$Cy = New-Object -TypeName Obviex.CipherLite.Crypto -ArgumentList $CyPw
$PwSec = $Cy.Encrypt($pw)
$Cy.Decrypt($PwSec)
