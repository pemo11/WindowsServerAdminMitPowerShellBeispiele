<#
 .Synopsis
 Einrichten der WinRM-Ports für eine Azure VM
 .Notes
 Noch nicht getestet
#>

$ResourceGroupName = "posh2018"

Login-AzureRmAccount

# Anlegen der ersten Regel für Port 5985
$WinRMRule = New-AzureRmNetworkSecurityRuleConfig `
    -Name "WinRM5985" `
    -Description "WinRM Access for Port 5985" `
    -Access "Allow" `
    -Protocol "Tcp" `
    -Direction "Inbound" `
    -Priority "100" `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 5985

$WinRMNsg = New-AzureRmNetworkSecurityGroup `
    -ResourceGroupName "$ResourceGroupName" `
    -Location "westeurope" `
    -Name "StandardSecurityGroup" `
    -SecurityRules $WinRMRule


$vnet = Get-AzureRmVirtualNetwork `
    -ResourceGroupName "$ResourceGroupName" `
    -Name "myVnet"

$subnetPrefix = $vnet.Subnets| Where-Object Name -eq "mySubnet"

Set-AzureRmVirtualNetworkSubnetConfig `
    -VirtualNetwork $vnet `
    -Name "mySubnet" `
    -AddressPrefix $subnetPrefix.AddressPrefix `
    -NetworkSecurityGroup $nsg

Set-AzureRmVirtualNetwork -VirtualNetwork $vnet