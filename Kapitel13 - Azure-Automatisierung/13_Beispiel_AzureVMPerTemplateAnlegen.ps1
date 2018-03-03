<#
 .Synopsis
 Anlegen einer Azure-VM über ein Template (Linux Ubuntu)
 .Notes
 Verbindung kann danach per SSH und dem Adminkonto und dem Kennwort hergestellt werden
#>

# Wichtig: Nicht interaktives Login funktioniert nur mit einem Geschäfts-/Schulkonto

$AzureUser = "psuser@pmactivetraining.onmicrosoft.com"
$AzureUserPw = Read-Host -Prompt "Pw?" -AsSecureString
$AzCred = [PSCredential]::new($AzureUser, $AzureUserPw)

try {
  Login-AzureRmAccount -Credential $AzCred -ErrorAction Stop
}
catch {
  Write-Warning "Fehler bei der Anmeldung ($_)"
  exit -1  
}

$ResourceGroupName = "posh2018"
$Location = "westeurope"
$TemplateURL = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-linux/azuredeploy.json"

# Ressourcengruppe gegebenenfalls anlegen
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Verbose -Force -ErrorAction Ignore

$DeploymentSettings = @{
  ResourceGroupName = $ResourceGroupName
  TemplateUri = $TemplateURL
  TemplateParameterObject = @{
    adminUserName = 'poshadmin'
    adminPassword = 'demo+123'
    dnsLabelPrefix = 'posh-arm'
  }
  Mode = 'Complete'
  Force = $true
  Name = 'TestDeployment'
}

# Parametersplatting!
New-AzureRmResourceGroupDeployment @DeploymentSettings -Verbose
