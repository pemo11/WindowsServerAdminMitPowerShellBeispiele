<#
 .Synopsis
 Anlegen einer Profilskriptdatei für den aktuellen Benutzer und alle Hosts
 .Notes
 Um nicht eine vorhandene Profile.ps1 zu überschreiben, heißt die angelegte
 Ps1-Datei Profile1.ps1
#>

configuration SetupPoshProfile
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {
        File PoshProfile1
        {
            Ensure = "Absent"
            DestinationPath = "C:\Users\$($Node.Username)\Documents\WindowsPowerShell\Poshprofile1.ps1"
            Contents = $Node.ProfileContent
        }
    }
}

$ProfileContent = @"
    # Automatically generated by DSC
"@

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "Localhost"
            Username = "PoshUser"
            ProfileContent = $ProfileContent
        }
    )
}

SetupPoshProfile -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\SetupPoshProfile -Wait -Verbose