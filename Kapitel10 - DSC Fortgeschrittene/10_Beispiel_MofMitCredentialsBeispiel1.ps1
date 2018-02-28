<#
 .Synopsis
 Speichern von Credentials in einer Konfiguration – Beispiel Nr. 1
#>

configuration CredentialsBeispiel1
{
  param([PSCredential]$Credential)

  Import-DSCResource -ModuleName PSDesiredStateConfiguration
  Import-DSCResource -ModuleName xActiveDirectory

  node Localhost
  {
    xADUser UserNeu
    {
      Ensure = "Present"
      UserName = $Node.Username
      DomainName = $Node.UserDomainName
      DisplayName = $Node.UserDisplayName
      Enabled = $true
      Password = $Credential
    }
  }
}


$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Username = "SpieltKeineRolle"
$PSCred = [PSCredential]::new($username, $PwSec)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "Localhost"
            Username = "DSCUser1"
            UserDomainName = "pshub.local"
            UserDisplayName = "DSC-Test User Nr. 1"
            PSDscAllowPlainTextPassword = $true
            $Credential = $PSCred
        }
    )
}


CredentialsBeispiel1 -ConfigurationData $ConfigData
