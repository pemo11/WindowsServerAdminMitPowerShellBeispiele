<#
 .Synopsis
 Ein SecureString wird mit einem eigenen Schlüssel in eine Zeichenkette konvertiert
#>

# Das Kennwort als SecureString holen
$PwSec = Read-Host -Prompt "Pw?" -AsSecureString

# Einen AES-Schlüssel anlegen
$AESKey = New-Object -TypeName "Byte[]" -ArgumentList 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)

# Das Kennwort als SecureString mit dem Key in eine Zeichenkette konvertieren
$Pw = ConvertFrom-SecureString -SecureString $PwSec -Key $AESKey

# Den Schlüssel in eine Datei speichern

$AESKeyFilePath = "AESKey.dat"
$PwPath = "Pw.dat"

$AESKey | Set-Content -Path $AESKeyFilePath

# Das Kennwort ebenfalls in eine Datei speichern
# Beide Dateien sollten per Zugriffsberechtigungen geschützt werden
$Pw | Set-Content -Path $PwPath

# Später wird das Kennwort wieder verwendet
$Pw = Get-Content -Path $PwPath

$AESKey = Get-Content -Path $AESKeyFilePath
$PwSecNeu = ConvertTo-SecureString -String $Pw -Key $AESKey

# Ein PSCredential-Objekt anlegen
$Cred = [PSCredential]::new("Administrator",$PwSecNeu)

# Credentials speichern
$Cred | Export-Clixml -Path .\Cred.xml
