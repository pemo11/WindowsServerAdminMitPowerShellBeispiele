<#
 .Synopsis
 Einen Systemdienst installieren
#>

configuration SetupQuoteService
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node $AllNodes.Nodename
  {
        Service SetupQuoteService
        {
            Ensure = "Present"
            Name = $Node.Servicename
            BuiltInAccount = $Node.ServiceAccount
            StartupType = $Node.StartupType
            Description = $Node.ServiceDescription
            DisplayName = $Node.ServiceDisplayName
            Path = $Node.ServiceFilePath
        }
  }
}

$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "localhost"
            Servicename = "Zitatedienst"
            ServiceAccount = "LocalSystem"
            StartupType = "Manual"
            ServiceDescription = "Originelle StarTrek-Zitate aus TOS"
            ServiceDisplayName = "TOS-Zitatedienst"
            ServiceFilePath = (Join-Path -Path $PSScriptRoot -ChildPath "Material\Zitatedienst.exe")
        }
    )

}

SetupQuoteService -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\SetupQuoteService -Wait -Verbose -Force