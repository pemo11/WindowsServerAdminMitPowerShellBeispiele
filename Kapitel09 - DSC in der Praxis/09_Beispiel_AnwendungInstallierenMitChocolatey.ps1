<#
 .Synopsis
 Anwendungen installieren per DSC und Chocolatey
 .Notes
 Setzt Chocolatey und das cChoco-Modul auf dem Node-Computer voraus
#>

configuration  SetupAppsWithChoco
{
    Import-DscResource -ModuleName  PSDesiredStateConfiguration
    Import-DscResource -ModuleName cChoco

    node $AllNodes.NodeName
    {
        cChocoPackageInstaller InstallVSCode
        {
            Ensure = "Present"
            Name = $Node.PackageName
        }

    }

}

$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "localhost"
            PackageName = "visualstudiocode"
        }

    )
}

SetupAppsWithChoco -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\SetupAppsWithChoco -Wait -Verbose -Force
