<#
 .Synopsis
 Konfiguration mit einem Neustart
#>

Configuration SetupNet47
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPendingReboot

    node $AllNodes.Nodename
    {

        Package net47setup
        {
            Name = ".NET Framework 4.7"
            Ensure = "Present"
            Path = $Node.ExePath
            Arguments = $Node.ExeArguments
            ProductId = ""
        }

        # Jetzt Neustart erzwingen
        xPendingReboot Reboot1
        { 
            Name = "CompleteSoftwareInstall"
        }

        # Für alle Fälle den LCM auf Neustart konfigurieren
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
            ExePath = "C:\Packages\Net47\NDP47-KB3186497-x86-x64-AllOS-ENU.exe"
            ExeArguments = "/q /norestart"
        }
    )
}

SetupNet47 -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Username = "Administrator"
$PSCred = [PSCredential]::new($username, $PwSec)

$CIMSession = New-CimSession -ComputerName W2016X -Credential $Cred
Set-DscLocalConfigurationManager -Path .\SetupNet47 -CimSession $CIMSession
$CIMSession | Remove-CimSession 

# Start-DscConfiguration -Path .\SetupNet47 -Wait -Verbose -Force -Credential $PSCred     