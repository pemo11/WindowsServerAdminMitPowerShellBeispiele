<#
 .Synopsis
 Einen Registry-Schlüssel per DSC anlegen
 .Description
 PsDscRunAsCredential ist erforderlich
#>

configuration CreateRegKeys
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  Node $AllNodes.NodeName
  {
    Registry Key1
    {
      Ensure = "Present"
      Key = "HKey_Current_User\Software\PsKurs"
      ValueName = "StartTermin"
      ValueData = "1.4.2017"
      ValueType = "String"
      PSDscRunAsCredential = $Node.Credential 
   }
   Registry Key2
   {
      Ensure = "Present"
      Key = "HKey_Current_User\Software\PsKurs"
      ValueName = "AnzahlTeilnehmer"
      ValueData = "7"
      ValueType = "Dword"
      PsDscRunAsCredential = $Node.Credential 
    }
  }
}

$ConfigData = @{

    AllNodes = @(
       @{
          NodeName = "Localhost"
          Credential = $PSCred
          PsDscAllowPlainTextPassword = $true
        }
      )
  }
  
$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Username = "SpieltKeineRolle"
$PSCred = [PSCredential]::new($username, $PwSec)

CreateRegKeys -ConfigurationData $ConfigData

Start-DscConfiguration -Path .\CreateRegKeys -Wait -Verbose -Force