<#
 .Synopsis
 Einen LCM für den Pull-Betrieb konfigurieren
#>

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            ServerUrl = "https://W2016A:8082/PSDSCPullServer.svc"
            # Wird für die Authentifizierung verwendet
            RegistrationKey = "9395af01-f2bb-41f0-90b3-fc3845c7525a"
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
            RefreshMode = "pull"
            # Konfigurationsdrift vermeiden
            ConfigurationMode = "ApplyAndAutoCorrect"
            AllowModuleOverwrite = $true
        }

        ConfigurationRepositoryWeb PullServer1
        {
            ServerURL = $Node.ServerURL
            RegistrationKey = $Node.RegistrationKey
            ConfigurationNames = @("BasicConfig")
            AllowUnsecureConnection = $true
        }

        ReportServerWeb ReportServer1
        {
            ServerURL = $Node.ServerURL
            RegistrationKey = $Node.RegistrationKey
            AllowUnsecureConnection = $true
        }
    }
}

LCMSetup -ConfigurationData $ConfigData