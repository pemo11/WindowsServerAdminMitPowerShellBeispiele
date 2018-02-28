<#
 .Synopsis
 Speichern von Credentials in einer Konfiguration – Beispiel Nr. 2
#>

configuration CredentialsBeispiel2
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

    LocalConfigurationManager
    {
        CertificateID = $Node.ThumbPrint
    }
  }
}

$CertThumb = (dir Cert:\LocalMachine\My -Eku "1.3.6.1.4.1.311.80.1"| 
 Where-Object Subject -eq "CN=DSC").Thumbprint

$ConfigData = @{

  AllNodes = @(
      @{
        NodeName = "Localhost"
        CertificateFile = "C:\PublicKeys\DSC.cer"
        Thumbprint = $CertThumb
      }
  )
}

CredentialsBeispiel2