<#
 .Synopsis
 Anlegen einer Azure-VM mit Functions
 .Notes
 Noch nicht getestet
#>

<#
 .Synopsis
 Login am Azure-Portal durchführen
#>
function New-AzLogin
{
    [CmdletBinding()]
    param([String]$Username, [SecureString]$Password)
    # Gibt es ein gespeichertes Profil?
    $AzureProfilePath = Join-Path -Path $PSScriptRoot -ChildPath Azureprofile.json
    if (Test-Path -Path $AzureProfilePath)
    {
        Import-AzureRmContext -Path $AzureProfilePath
    }
    else
    {
        $AzureCred = [PSCredential]::new($Username, $Password)
        Login-AzureRmAccount -Credential $AzureCred | Out-Null
        # Speichern des Profils
        Save-AzureRmContext -Path $AzureProfilePath
    }
}

<#
 .Synopsis
 Eine Ressourcengruppe anlegen
#>
function New-AzResourceGroup
{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][String]$Name, [String]$Location="westeurope")
    try
    {
        # Nur anlegen, wenn sie noch nicht existiert
        Get-AzureRmResourceGroup -Name $Name -Location $Location -ErrorAction Stop | Out-Null
        Write-Verbose "Die Ressourcengruppe $RessourceGroupName gibt es bereits."
    }
    catch
    {
        # Anlegen der Ressourcengruppe
        New-AzureRmResourceGroup -Name $RessourceGroupName -Location $Location 
    }
}

<#
 .Synopsis
 Ein Speicherkonto anlegen
#>
function New-AzStorageAccount
{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][String]$Name, 
          [Parameter(Mandatory=$true)][String]$ResourceGroupName, 
          [String]$Location="westeurope")
    $NameIndex = 0
    do
    {
        # Wichtig: Das Speicherkonto benötigt einen eindeutigen Namen
        $NameIndex++
        $StorageAccountName = "$Name{0:00}" -f $NameIndex
    } until ((Get-AzureRmStorageAccountNameAvailability -Name $StorageAccountName).NameAvailable)

    # Das Speicherkonto wird in der Ressourcengruppe angelegt
    New-AzureRmStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName  -Location $Location -SkuName Standard_LRS
    # $StorageAccount = Get-AzureRmStorageAccount -ResourceGroupName $RessourceGroupName -StorageAccountName $StorageAccountName
}

<#
 .Synopsis
 Eine Public IP-Adresse anlegen
#>
function New-AzIPAddress
{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][String]$Name, 
          [Parameter(Mandatory=$true)][String]$ResourceGroupName,
          [String]$Location="westeurope")
    New-AzureRmPublicIpAddress -Name $Name `
     -ResourceGroupName $RessourceGroupName `
     -DomainNameLabel $DomNameLabel   `
     -Location $Location `
     -AllocationMethod Dynamic -Force
}

<#
 .Synopsis
 Ein Subnetz anlegen
#>
function New-AzSubnet
{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][String]$Name, 
          [Parameter(Mandatory=$true)][String]$IPSubNetRange
    )
    New-AzureRmVirtualNetworkSubnetConfig -Name $Name `
        -AddressPrefix $IPSubNetRange
}

<#
 .Synopsis
 Ein virtuelles Netzwerk anlegen
#>
function New-AzVirtualNetwork
{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][String]$Name, 
          [Parameter(Mandatory=$true)][String]$IPRange, 
          [Parameter(Mandatory=$true)][String]$Subnet, 
          [Parameter(Mandatory=$true)][String]$ResourceGroupName,
          [String]$Location="westeurope"
          )
    try
    {
        # Gibt es das virtuelle Netzwerk bereits?
        $Vnet = Get-AzureRmVirtualNetwork -Name $VnetName `
         -ResourceGroupName $ResourceGroupName -ErrorAction Stop
        Write-Verbose "$Vnet gibt es bereits..."
    }
    catch
    {
        # Virtuelles Netzwerk anlegen
        New-AzureRmVirtualNetwork -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -Location $Location -AddressPrefix $IPRange `
        -Subnet $Subnet -Force
    }
}

<#
 .Synopsis
 Einen Netzwerkadapter anlegen
#>
function New-AzNetworkAdapter
{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][String]$Name, 
    [Parameter(Mandatory=$true)][String]$PublicIP, 
    [Parameter(Mandatory=$true)][String]$SubnetId, 
    [Parameter(Mandatory=$true)][String]$ResourceGroupName,
    [String]$Location="westeurope"
    )
    New-AzureRmNetworkInterface -Name "$VmName`_Nic1" -Location $Location `
        -ResourceGroupName $RessourceGroupName `
        -SubnetId $SubnetId
        -PublicIpAddressId $PublicIP -Force
} 

<#
 .Synopsis
 Eine Vm mit VM-Konfiguration anlegen
#>
function New-AzVm
{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][String]$Name,
          [Parameter(Mandatory=$true)][Int64]$VMSize,
          [Parameter(Mandatory=$true)][String]$NicID,
          [Parameter(Mandatory=$true)][String]$ResourceGroupName,
          [String]$Location="westeurope")
          $NewVm = New-AzureRmVMConfig -Name $VmName -VMSize $VmSize
          $NewVm = Add-AzureRmVMNetworkInterface -VM $NewVm -Id $NicID
          New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $NewVm
          $NewVm
}

<#
 .Synopsis
 Eine VM mit einem OS bestücken
#>
function Set-AzVmWindowsOS
{
    param([Parameter(Mandatory=$true)][Object]$VM,
    [Parameter(Mandatory=$true)][Object],
    [String]$Computername,
    [PSCredential]$AdminCredential,
    [Object]$VMImage,
    [String]$DiskName,
    [String]$VhdUrhi
    )
    # Der VM ein Betriebssystem zuordnen
    Set-AzureRmVMOperatingSystem -Windows -VM $VM -ProvisionVMAgent `
     -EnableAutoUpdate:$true -ComputerName $VmName -Credential $AdminCredential
    # Der VM ein Image zuordnen
    Set-AzureRmVMSourceImage -VM $NewVM `
        -PublisherName $VMImage.PublisherName `
        -Offer $VMImage.Offer `
        -Skus $VMImage.Skus `
        -Version $VMImage.Version
    # Die Laufwerkseigenschaften setzen
    Set-AzureRmVMOSDisk -VM $VM -Name $DiskName `
        -VhdUri $VhdUri -Caching ReadWrite -CreateOption FromImage
}

# Schritt 1: Definieren von Variablen für die VM
$ResourceGroupName ="posh2018A"
$Location = "westeurope"
$VnetName = "StandardVnet"
$IpAddress = "10.0.0.12"
$IpRange = "10.0.0.0/16"
$IpSubNetRange = "10.0.0.0/24"
$Subnetname = "Subnet-1"
$VmSize = "Basic_A0" 
$OSSKU = "2012-R2-Datacenter"
$VmName = "PoshVM1"
$StorageAccountName = "poshvmstore"
$DomNameLabel  = "poshvm"

# Schritt 2: Anmelden am Azure-Portal
$AzureUser = "psuser@pmactivetraining.onmicrosoft.com"
$AzureUserPw = Read-Host -Prompt "Pw?" -AsSecureString
Azure-Login -Username $AzureUser -Password $AzureUserPw

# Schritt 3: Benutzername und Kennwort für das Admin-Konto festlegen
$Username = "poshadmin" 
$Password = "demo+123"
$PasswordSec = $Password | ConvertTo-SecureString -AsPlaintext -Force 
$Cred = [PSCredential]::new($Username, $PasswordSec)

# Schritt 4: Anlegen bzw. holen einer Ressourcengruppe
New-AzResourceGroup -Name $ResourceGroupName -Verbose

# Schritt 5: Anlegen eines Speicherkontos
New-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName

# Schritt 6: Name und Uri für die Laufwerksdatei festlegen
$DiskNameOS = $VmName + "_DiskOS"
$VhdUri = $StorageAccount.PrimaryEndpoints.Blob + "vhds/$DiskNameOS.vhd"

# Schritt 7: Image-Dateien holen
$VmImages = Get-AzureRmVMImage -Location $Location -PublisherName "MicrosoftWindowsServer" `
 -Offer "WindowsServer" -Skus $OsSKU | Sort-Object -Descending -Property PublishedDate

# Schritt 8: Eine öffentliche IP-Adresse in der Ressourcengruppe anlegen
$PublicIP = New-AzIPAddress -Name "$VmName`_IP1" -ResourceGroupName $ResourceGroupName

# Schritt 9: Ein Subnet erstellen
$Subnet1 = New-AzSubnet -Name $Subnetname -AddressPrefix $IpSubNetRange

# Schritt 10: Anlegen eines virtuellen Netzwerks
$VNet = New-AzVirtualNetwork -Name $VNetName -ResourceGroupname $ResourceGroupName -IPRange $IPRange -Subnet $Subnet1
# $Subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet

# Schritt 11: Netzwerkadapter in der Ressourcengruppe anlegen
$NIC = New-AzNetworkAdapter -Name "$VmName`_Nic1" -ResourceGroupName $ResourceGroupName `
 -SubnetId $Vnet.Subnets[0].Id -PublicIP $PublicIP.Id

# Schritt 12: Anlegen einer nackten VM mit einer VM-Konfiguration
$NewVM = New-AzVm -Name $VMname -VMSize $VmSize -NicId $NIC.Id -ResourceGroupName $ResourceGroupName

# Schritt 13: Die VM für ein Betriebssystem konfigurieren
Set-AzVmWindowsOS -VM $NewVM -ComputerName $VmName -AdminCredential $Cred `
 -VMImage $VmImages[0] -DiskName $DiskNameOS -VhdUri $VhdUri

# Schritt 14: Die VM wird gestartet
Start-AzureRmVM -Name $VmName -ResourceGroupName $ResourceGroupName  -Verbose

# $AzureRmVM = Get-AzureRmVm -ResourceGroupName $ResourceGroupName -Name $VmName
# $AzureRmVM

# RPD-Adresse ableiten und RDP-Verbindung herstellen
$RdpURL = "$($PublicIP.DnsSettings.Fqdn):3389"

Start-Process -FilePath mstsc -ArgumentList "/v:$RdpURL"
