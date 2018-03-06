<#
 .Synopsis
 Anlegen einer Freigabe auf einem Node mit xSMBShare
#>

Configuration SetupShare
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xSMBShare

    node $AllNodes.Nodename
    {
        file PoshDir
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshDir"
            Type = "Directory"
        }

        xSmbShare PoshDirShare
        {
            Ensure = "Present"
            Name = "PoshDir"
            FullAccess = "Everyone"
            Path = "C:\PoshDir"
            DependsOn = "[File]PoshDir"
            
        }
    }
}

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::New("Administrator", $PwSec)

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "localhost"
        }
    )
}

SetupShare -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\SetupShare -Wait -Verbose -Force -Credential $PSCred


