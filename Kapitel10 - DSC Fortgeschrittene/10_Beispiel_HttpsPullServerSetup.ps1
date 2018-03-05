<#
 .Synopsis
 Einen HTTPS-Pull Server einrichten
#>

configuration SetupDSCPullserver1
{
    param(
      [Parameter(Mandatory=$true)]
      [String]$CertThumbPrint,
      [ValidateNotNullOrEmpty()]
      [String]$RegistrationKey
  )

  Import-DSCResource -ModuleName xPSDesiredStateConfiguration
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node Localhost
  {
 
    WindowsFeature DSCServiceFeature
    {
        Ensure = "Present"
        Name = "DSC-Service"
    }

    xDSCWebService PSDSCPullServer
    {
        Ensure = "Present"
        DependsOn = "[WindowsFeature]DSCServiceFeature"
        EndpointName = "PSDSCPullServer"
        Port = 8088
        PhysicalPath = "$env:SystemDrive\inetpub\PSDSCPullServer"
        CertificateThumbPrint = $CertThumbPrint
        ModulePath = "$env:ProgramFiles\WindowsPowerShell\DscService\Modules"
        ConfigurationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
        State = "Started"
        UseSecurityBestPractices = $false
      }

      file RegistrationKeyFile
      {
        Ensure = "Present"
        Type = "File"
        DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\Registrationkeys.txt"
        Contents = $RegistrationKey
      }
  }
}

SetupDSCPullserver1

Start-DSCConfiguration  -Path .\SetupDSCPullserver1 -Verbose -Wait -Force