<#
 .Synopsis
 Anlegen einer Azure-VM über ein Template
#>

$ResourceGroupName = "Pemo2017Ressourcen"
$TemplateURL = https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-linux/azuredeploy.json

$DeploymentSettings = @{
  ResourceGroupName = $ResourceGroupName
  TemplateUri = $TemplateURL
  TemplateParameterObject = @{
    adminUserName = 'PemoAdmin'
    adminPassword = 'demo+123'
    dnsLabelPrefix = 'pm-arm'
  }
  Mode = 'Complete'
  Force = $true
  Name = 'TestDeployment'
}

New-AzureRmResourceGroupDeployment @DeploymentSettings –Verbose
