<#
 .Synopsis
 Einen LCM für den Pull-Betrieb mit partiellen Konfigurationen konfigurieren
#>

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            ServerUrl1 = "http://W2016A:8082/PSDSCPullServer.svc"
            ServerUrl2 = "http://W2016B:8080/PSDSCPullServer.svc"
            # Wird für die Authentifizierung verwendet
            RegistrationKey1 = "9395af01-f2bb-41f0-90b3-fc3845c7525a"
            RegistrationKey2 = "707cc887-1206-4918-b815-759698dfcfee"
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
            ServerURL = $Node.ServerURL1
            RegistrationKey = $Node.RegistrationKey1
            ConfigurationNames = @("BasicConfig")
            AllowUnsecureConnection = $true
        }

        ConfigurationRepositoryWeb PullServer2
        {
            ServerURL = $Node.ServerURL2
            RegistrationKey = $Node.RegistrationKey2
            ConfigurationNames = @("AppConfig")
            AllowUnsecureConnection = $true
        }

        PartialConfiguration BasicConfig
        {
            Description = "Only for the Basic settings"
            ConfigurationSource = "[ConfigurationRepositoryWeb]PullServer1"
            RefreshMode = "Pull"
        }


        PartialConfiguration AppConfig
        {
            Description = "For the Application installation"
            ConfigurationSource = "[ConfigurationRepositoryWeb]PullServer2"
            RefreshMode = "Pull"
        }

        ReportServerWeb ReportServer1
        {
            ServerURL = $Node.ServerURL1
            RegistrationKey = $Node.RegistrationKey1
            AllowUnsecureConnection = $true
        }

    }
}

LCMSetup -ConfigurationData $ConfigData

Set-DscLocalConfigurationManager -Path .\LCMSetup -Verbose 