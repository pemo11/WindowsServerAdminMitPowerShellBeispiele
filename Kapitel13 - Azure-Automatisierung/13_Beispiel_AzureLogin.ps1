<#
 .Synopsis
 Login am Azure-Portal
#>

# Für alle Fälle das Module AzureRM.Profile aktualisieren
# Install-Module -Name AzureRM.Profile -Force

# Typ: Microsoft.Azure.Commands.Profile.Models.PSAzureProfile
$AzureProfile = Login-AzureRmAccount

# Falls diese Angaben benötigt werden
$SubscriptionId = $AzureProfile.$SubscriptionId
$TenantId = $AzureProfile.$TenantId

# Danach z.B. alle Ressourcegruppen auflisten
# Get-AzureRmResourceGroup

# Anlegen einer Ressourcengruppe

$ResourceGroupName = "posh2018"
if (-not (Find-AzureRmResourceGroup -Tag @{ Name = $ResourceGroupName }))
{
    # Ressourcengruppe anlegen - bei Location kommt es auf die Schreibweise an
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location "westeurope"
}

# Alle Ressourcegruppen auflisten
Get-AzureRmResourceGroup
