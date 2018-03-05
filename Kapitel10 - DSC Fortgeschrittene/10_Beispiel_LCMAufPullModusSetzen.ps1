<#
 .Synopsis
 Einen LCM für den Pull-Betrieb konfigurieren
#>

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            ServerUrl = "https://PMServer:8088/PSDSCPullServer.svc"
            RegistrationKey = "a017fb5b-1808-48f3-acc4-17e6a72138c1"
        }
    )
}

[DSCLocalConfigurationManager()]
configuration LCMSetup
{
    node localhost
    {
      Settings
      {
          RefreshMode = "Pull"
          # Konfigurationsdrift vermeiden
          ConfigurationMode = "ApplyAndAutoCorrect"
          AllowModuleOverwrite = $true
      }

      ConfigurationRepositoryWeb PullServer1
      {
          ServerURL = $Node.ServerURL
          RegistrationKey = $Node.RegistrationKey
          ConfigurationNames = @("StandardConfig")
      }

      ReportServerWeb ReportServer1
      {
        ServerURL = $Node.ServerURL
        RegistrationKey = $Node.RegistrationKey
      }
    }
}

LCMSetup -ConfigurationData $ConfigData