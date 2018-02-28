<#
 .Synopsis
 Windows-Feature anlegen per DSC
 .Notes
 Funktioniert nur unter Windows Server
#>

configuration FeatureBeispiel
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node $AllNodes.Nodename
  {
    WindowsFeature Feature1
    {
      Ensure = "Present"
      Name = $Node.FeatureName
      LogPath = $Node.FeatureLogPath
    }
  }
}

$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "localhost"
            LogPath = "C:\FeatureInstall.log"
            FeatureName = "WindowsPowerShellWebAccess"
        }
    )

}

FeatureBeispiel -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\FeatureBeispiel -Wait -Verbose -Force