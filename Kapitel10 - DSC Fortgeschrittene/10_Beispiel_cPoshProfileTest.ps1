<#
 .Synopsis
 Test der selbst definierten Ressource cPoshProfile
#>

configuration PoshProfileSetup
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName cPoshProfile

    node $AllNodes.NodeName
    {
        cPoshProfileResource Profile1
        {
            Ensure = "Present"
            Username = $Node.Username
        }
    
    }

}

$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "Localhost"
            Username = "Spezial"
        }
    )
}

PoshProfileSetup -ConfigurationData $ConfigData

Start-DscConfiguration -Path .\PoshProfileSetup -Wait -Verbose -Force