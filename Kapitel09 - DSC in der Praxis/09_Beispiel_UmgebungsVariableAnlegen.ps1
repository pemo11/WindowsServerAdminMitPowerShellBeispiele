<#
 .Synopsis
 Eine System-Umgebungsvariable anlegen
#>

configuration EnvironmentBeispiel
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node $AllNodes.Nodename
  {
    File Dir1
    {
      Ensure = "Present"
      DestinationPath = $Node.DirPath
      Type = "Directory"
    }

    Environment Env1
    {
      Ensure = "Present"
      Name = "Path"
      Path = $true
      Value = $Node.DirPath
      DependsOn = "[File]Dir1"
    }
  }
}

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            DirPath = "C:\PsTools"
        }
    )
}

EnvironmentBeispiel -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\EnvironmentBeispiel -Wait -Verbose -Force