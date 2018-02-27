<#
 .Synopsis
 Anlegen einer Profilskriptdatei
#>

configuration ProfilSkriptBeispiel
{
  param([String]$Username="Administrator")
 
  Import-DSCResource -ModuleName PSDesiredStateConfiguration
 
  node $AllNodes.NodeName
  {
    File ProfileDir
    {
      Ensure = "Present"
      DestinationPath = "C:\Users\$Username\Documents\WindowsPowerShell"
      Type = "Directory"
      Force = $true
    }

    File ProfileFile
    {
      Ensure = "Present"
      DestinationPath = "C:\Users\$Username\Documents\WindowsPowerShell\ProfileX.ps1"
      Contents = $AllNodes.ProfileContent
      Type = "File"
      DependsOn = "[File]ProfileDir"
     }
  }
}

$ConfigData = @{

  AllNodes = @(
     @{
       NodeName = "Localhost"
       ProfileContent = "`$Host.PrivateData.ErrorBackgroundColor = 'White'"
    }
  )
}

ProfilSkriptBeispiel -Username PsUser -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\ProfilSkriptBeispiel -Wait -Verbose -Force