<#
 .Synopsis
 Kopieren eines Zertifikats
 .Notes
 Setzt eine Administrtor-Shell voraus
#>
function Copy-Cert
{
    [CmdletBinding()]
    param([System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert,
          [String]$StoreScopeDest,
          [String]$StoreNameDest)
    
    $DestStore = Get-Item -Path "Cert:\$StoreScopeDest\$StoreNameDest"
    $DestStore.Open("ReadWrite")
    $DestStore.Add($Cert)
    $DestStore.Close()
}

# Ein Beispiel für das Kopieren eines vorhandenen Zertifikats
New-SelfSignedCertificate -DNSName "PsKurs" -CertStoreLocation "cert:\currentuser\my"

$Cert = (Get-ChildItem cert:\CurrentUser -Recurse | Where-Object Subject -eq "CN=PsKurs")[0]

Copy-Cert -Cert $Cert -StoreScopeDest Localmachine -StoreNameDest my