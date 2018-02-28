<#
 .Synopsis
 Abhängigkeiten zwischen DSC-Ressourcen
#>

configuration PoshWebsiteSetup
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xWebAdministration
    
    node $AllNodes.Nodename
    {

        File DefaultPage
        {
            Ensure = "Present"
            DestinationPath = $Node.DefaultPagePath
            Contents = $Node.DefaultPageContent
        }

        xWebsite PoshSite
        {
            Ensure = "Present"
            Name = $Node.Sitename
            State = "Started"
            PhysicalPath = $Node.SitePath
            DependsOn = "[WindowsFeature]IIS"
            BindingInfo = MSFT_xWebBindingInformation
                            {
                            Protocol = "HTTP"
                            Port = 8000
                            }
        }

        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
            IncludeAllSubFeature = $true
        }
   }
}

$ConfigData = @{

    AllNodes = @(
        @{
            SiteName = "PoshSite"
            SitePath = "C:\Webserver\htdocs"
            DefaultPagePath = "C:\Webserver\htdocs\Default.htm"
            DefaultPageContent = "<H3>Alles klar mit DSC!</H3>"
        }
    )
}

PoshWebsiteSetup -ConfigurationData $ConfigData

Start-DSCConfiguration -Path .\PoshWebsiteSetup -Verbose -Wait -Force