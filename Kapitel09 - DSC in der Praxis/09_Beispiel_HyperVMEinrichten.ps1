<#
 .Synopsis
 Hyper VM per DSC anlegen
 .Notes
 Pfad für Vhd-Datei anpassen
#>

configuration HyperVSetupVM
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xHyper-V
  
    node $AllNodes.NodeName
    {
        xVMHyperV DSCServerVm
        {
            Ensure = "Present"
            Name = "DSCServer"
            Generation = 1
            StartupMemory = 1024MB
            EnableGuestService = $true
            ProcessorCount = 2
            SwitchName = "ExternesNetzwerk"
            VhdPath = $Node.VhdPath
            State = "Running"
        }
    }
}
  
$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "localhost"
            VhdPath = "E:\HyperV\Virtual Hard Disks\WindowsServer2012R2.vhdx"
            VhdSize = 64GB
        }
    )
}
  
HyperVSetupVM -ConfigurationData $ConfigData

Start-DscConfiguration -Path .\HyperVSetupVM -Wait -Verbose -Force
