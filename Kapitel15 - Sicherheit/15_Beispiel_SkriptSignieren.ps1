<#
 .Synopsis
 Ein Skript signieren
#>

$PS1Code = @'
    $Startzeit = Get-Date
    1..10 | ForEach {
        "Durchlauf Nr. {0} nach {1:n2} ms" -f $_, ((Get-Date)-$Startzeit).TotalMilliSeconds
    }
'@

$Ps1Pfad = Join-Path -Path $PSScriptRoot -ChildPath Test.ps1
$PS1Code | Set-Content -Path $Ps1Pfad

# Zertifikat für Codesignierung anlegen falls nicht vorhanden
if ((Get-ChildItem -Path Cert:\CurrentUser\my -CodeSigningCert) -eq $null)
{
    New-SelfSignedCertificateEx -Subject "CN=PSKurs" -StoreLocation CurrentUser -EnhancedKeyUsage "Codesignatur"
}

# Zertifikat holen - es sollte nur eines geben
$Cert = (Get-ChildItem -Path Cert:\CurrentUser -Recurse -CodeSigningCert |
  Where-Object Subject -eq "CN=PsKurs")[0]

# Wenn kein Zertifikat vorhanden geht es nicht weiter
if ($Cert -eq $null)
{
    throw "Kein Zertifikat gefunden"
    break
}

# Wichtig: Das Zertifikat muss auch in die Ablage "Vertrauenswürdige Stammzertifizierungsstellen" kopiert werden

# Geht leider nicht
# Copy-Item -Path $Cert.PSPath -Destination Cert:\CurrentUser\Root

# Verwendung der Copy-Cert-Function aus Kapitel 15
. .\15_Beispiel_CopyCert.ps1

Copy-Cert -Cert $Cert -StoreScopeDest CurrentUser -StoreNameDest Root

# Jetzt wird das Skript signiert
Set-AuthenticodeSignature -Certificate $Cert -FilePath $Ps1Pfad  -Force -Verbose

# Signatur prüfen
Get-AuthenticodeSignature -FilePath $Ps1Pfad

# Policy ändern
$OldPolicy = Get-ExecutionPolicy -Scope CurrentUser

Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope CurrentUser

# Signiertes Skript ausführen - wird hier "Immer ausführen" gewählt, wird das Zertifkat auch in die Ablage "TrustedPublisher" kopiert
# Bei "nie ausführen" -> CurrentUser\Disallowed (Nicht vertrauenswürdige Zertifikate\Zertifkate)

.$Ps1Pfad

# Alte Policy wiederherstellen
Set-ExecutionPolicy -ExecutionPolicy $OldPolicy -Scope CurrentUser

# Im Rahmen der Übung die angelegten Zertfikate wieder aus den Ablagen cert:\currentuser\my und cert:\currentuser\root löschen

Get-ChildItem -Path Cert:\CurrentUser -Recurse | 
 Where-Object Subject -eq "CN=PsKurs" |
 Remove-Item -Verbose