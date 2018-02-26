<#
 .Synopsis
 Eine PowerShell-Klasse mit versteckten Members
 .Notes
 Beim Ausführen in VS Code kommt es zu einem Fehler - der Wert von $Password wird nicht erkannt, obwohl der Wert vorhanden ist
#>

class PSCredentialEx
{
  hidden[String]$UserName
  hidden[PSCredential]$Credential

  PSCredentialEx([String]$Username, [String]$Password)
  {
     $this.UserName = $Username
     $PwSec = $Password | ConvertTo-SecureString -AsPlainText ?Force -Verbose
     $this.Credential = [PSCredential]::new($Username, $PwSec)
  }

  [PSCredential]GetCredential()
  {
     return $this.Credential
  }
}

$Username = "Administrator"
$Password = "demo+123"

# Dem Konstruktor werden zwei Parameterwerte übergeben
$Cred = [PSCredentialEx]::new($Username, $Password)
$Cred.GetCredential()