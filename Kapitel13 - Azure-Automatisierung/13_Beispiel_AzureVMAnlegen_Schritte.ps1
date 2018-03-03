<#
 .Synopsis
 Anlegen einer Azure-VM
 .Notes
 Läuft fehlerfrei durch - 02/03/2018
#>

# Schritt 1: Anmelden am Azure-Portal

# Wichtig: Bei Anmeldung mit einem privaten Microsoft-Konto ist immer eine
# interaktive Anmeldung erforderlich
# Das Speichern eines Profils bzw. des Kontext funktioniert nur mit einem
# Geschäfts- oder Schulkonto bzw. einem Azure AD-Konto

$AzureUser = "psuser@pmactivetraining.onmicrosoft.com"
$AzureUserPw = Read-Host -Prompt "Pw?" -AsSecureString
$AzureCred = [PSCredential]::new($AzureUser, $AzureUserPw)

# Die Variable $AzureProfile wird in diesem Skript nicht verwendet
$AzureProfile = Login-AzureRmAccount -Credential $AzureCred

$AzureProfilePath = Join-Path -Path $PSScriptRoot -ChildPath Azureprofile.json

# Gibt es ein gespeichertes Profil?
if (Test-Path -Path $AzureProfilePath)
{
    Import-AzureRmContext -Path $AzureProfilePath
}
else
{
    # $AzureProfile = Login-AzureRmAccount
    # Speichern des Profils
    Save-AzureRmContext  -Path $AzureProfilePath
}
#>
# Schritt 2: Auswahl einer Subscription - dieser Schritt ist optional
#Select-AzureRmSubscription -SubscriptionId $AzureProfile.Context.Subscription.SubscriptionId `
# -TenantId $AzureProfile.Context.Tenant.TenantId

# Schritt 3: Definieren von Variablen für die VM
# Wichtig. Alle diese Angaben müssen gegebenenfalls geändert werden
$RessourceGroupName ="posh2018"
$Location = "westeurope"
$VnetName = "StandardVnet"
$IpAddress = "10.0.0.12"
$IpRange = "10.0.0.0/16"
$IpSubNetRange = "10.0.0.0/24"
$Subnetname = "Subnet-1"
$VmSize = "Basic_A0" 
$OSSKU = "2012-R2-Datacenter"
$VmName = "PoshVM1"
$StorageAccountName = ""
$DomNameLabel  = "poshvm"

# Schritt 4: Benutzername und Kennwort für das Admin-Konto festlegen
$Username = "poshadmin" 
$Password = "demo+123"
$PasswordSec = $Password | ConvertTo-SecureString -AsPlaintext -Force 
$Cred = [PSCredential]::new($Username, $PasswordSec)

# Schritt 5: Anlegen einer neuen Ressourcengruppe
try
{
    # Nur anlegen, wenn sie noch nicht existiert
    Get-AzureRmResourceGroup -Name $RessourceGroupName -Location $Location -ErrorAction Stop | Out-Null
    Write-Verbose "Die Ressourcengruppe $RessourceGroupName gibt es bereits." -Verbose
}
catch
{
    # Anlegen der Ressourcengruppe
    New-AzureRmResourceGroup -Name $RessourceGroupName -Location $Location -Verbose
}

# Schritt 6: Anlegen eines Speicherkontos
$StorageNameIndex = 0
do
{
    # Wichtig: Das Speicherkonto benötigt einen eindeutigen Namen
    $StorageNameIndex++
    $StorageAccountName = "poshvmstore{0:00}" -f $StorageNameIndex
} until ((Get-AzureRmStorageAccountNameAvailability -Name $StorageAccountName).NameAvailable)

# Das Speicherkonto wird in der Ressourcengruppe angelegt
New-AzureRmStorageAccount -Name $StorageAccountName -ResourceGroupName $RessourceGroupName  -Location $Location -SkuName Standard_LRS
$StorageAccount = Get-AzureRmStorageAccount -ResourceGroupName $RessourceGroupName -StorageAccountName $StorageAccountName

# Schritt 7: Die Uri für die Vhd im Speicherbereich holen
$DiskNameOS = $VmName + "_DiskOS"
$VhdUri = $StorageAccount.PrimaryEndpoints.Blob + "vhds/$DiskNameOS.vhd"

# Schritt 8: Image-Datei holen
$VmImages = Get-AzureRmVMImage -Location $Location -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus $OsSKU | Sort-Object -Descending -Property PublishedDate

# Schritt 9: Eine öffentliche IP-Adresse in der Ressourcengruppe anlegen
$PublicIP = New-AzureRmPublicIpAddress -Name "$VmName`_IP1" `
 -ResourceGroupName $RessourceGroupName `
 -DomainNameLabel $DomNameLabel   `
 -Location $Location `
 -AllocationMethod Dynamic -Force

# Schritt 10: Ein Subnet erstellen
$Subnet1 = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName `
 -AddressPrefix $IPSubNetRange

# Schritt 11: Anlegen eines virtuellen Netzwerks
try
{
    # Gibt es das virtuelle Netzwerk bereits?
    $Vnet = Get-AzureRmVirtualNetwork -Name $VnetName `
     -ResourceGroupName $RessourceGroupName -ErrorAction Stop
    Write-Verbose "$VNET gibt es bereits..." -Verbose
}
catch
{
    # Virtuelles Netzwerk anlegen
    $Vnet = New-AzureRmVirtualNetwork -Name $VnetName `
     -ResourceGroupName $RessourceGroupName `
     -Location $Location -AddressPrefix $IPRange `
     -Subnet $Subnet1 -Force
}

$Subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet

# Schritt 12: Netzwerkadapter in der Ressourcengruppe anlegen
$NIC = New-AzureRmNetworkInterface -Name "$VmName`_Nic1" -Location $Location `
 -ResourceGroupName $RessourceGroupName `
 -SubnetId $Vnet.Subnets[0].Id `
 -PublicIpAddressId $PublicIP.Id -Force

# Schritt 13: VM-Konfiguration anlegen
$NewVM = New-AzureRmVMConfig -Name $VmName -VMSize $VmSize
$NewVM = Add-AzureRmVMNetworkInterface -VM $NewVM -Id $NIC.Id

# Schritt 14: Der VM ein Betriebssystem zuordnen
Set-AzureRmVMOperatingSystem -Windows -VM $NewVM -ProvisionVMAgent `
 -EnableAutoUpdate:$false -ComputerName $VmName -Credential $Cred

# Schritt 15: Der VM ein Image zuordnen
Set-AzureRmVMSourceImage -VM $NewVM -PublisherName $VmImages[0].PublisherName -Offer $VmImages[0].Offer -Skus $VmImages[0].Skus -Version $VmImages[0].Version

# Schritt 16: Die Laufwerkseigenschaften setzen
Set-AzureRmVMOSDisk -VM $NewVM -Name $DisknameOS `
 -VhdUri $VhdUri -Caching ReadWrite -CreateOption FromImage

# Schritt 17: Die VM wird endlich angelegt
New-AzureRmVM -ResourceGroupName $RessourceGroupName -Location $Location -VM $NewVM -Verbose

# Schritt 18: Die VM wird gestartet
Start-AzureRmVM -Name $VmName -ResourceGroupName $RessourceGroupName  -Verbose

# Schritt 19: RPD-Adresse ableiten
$AzureRmVM = Get-AzureRmVm -ResourceGroupName $RessourceGroupName -Name $VmName
$AzureRmVM

$RdpURL = "$($PublicIP.DnsSettings.Fqdn):3389"

# Schritt 20: RDP-Verbindung herstellen
Start-Process -FilePath mstsc -ArgumentList "/v:$RdpURL"
