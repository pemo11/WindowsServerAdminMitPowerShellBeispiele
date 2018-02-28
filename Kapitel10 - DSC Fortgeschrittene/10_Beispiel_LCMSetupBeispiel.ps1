<#
 .Synopsis
 LCM für Reboot konfigurieren
#>

[DSCLocalConfigurationManager()]
configuration LCMSetup
{

    node Localhost
    {
        settings
        {
            RebootNodeIfNeeded = $true
            ConfigurationMode = "ApplyOnly"
            ActionAfterReboot =  "ContinueConfiguration"
        }
    }
}

LCMSetup

Set-DscLocalConfigurationManager -Path .\LCMSetup -Verbose 

Get-DscLocalConfigurationManager