<#
 .Synopsis
 Neustart während einer Konfiguration
#>

Configuration SetupWithReboot
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.Nodename
    {
        Script Reboot
        {
            TestScript = {
                return (Test-Path -Path HKCU:\Software\DSCTest\RebootFlag)
            }
            SetScript = {
                New-Item -Path HKCU:\Software\DSCTest\RebootFlag -Force
                $Global:DSCMachineStatus = 1
            }

            GetScript = { return @{result = "Result"}}
        }

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "W2016X"
        }
    )
}

SetupWithReboot -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::New("Administrator", $PwSec)

Set-DscLocalConfigurationManager -Path .\SetupWithReboot -ComputerName W2016X -Credential $PSCred -Verbose

# Start-DscConfiguration -Path .\SetupWithReboot -Credential $PSCred -Wait -Verbose -Force
