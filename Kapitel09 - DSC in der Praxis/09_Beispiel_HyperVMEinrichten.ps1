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
            Name = $Node.VMName
            Generation = 1
            StartupMemory = $Node.StartupMemory
            EnableGuestService = $true
            ProcessorCount = $Node.ProcessorCount
            SwitchName = $Node.SwitchName
            VhdPath = $Node.VhdPath
            State = "Running"
        }
    }
}
  
$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "localhost"
            VMName = "DSCServer"
            StartupMemory = 1024MB
            ProcessorCount = 2
            SwitchName = "ExternesNetzwerk"
            VhdPath = "E:\HyperV\Virtual Hard Disks\WindowsServer2012R2.vhdx"
            VhdSize = 64GB
        }
    )
}
  
HyperVSetupVM -ConfigurationData $ConfigData

Start-DscConfiguration -Path .\HyperVSetupVM -Wait -Verbose -Force
