<#
 .Synopsis
 Eine Web-App einrichten per DSC
 .Notes
 Kann nur unter Windows Server ausgeführt werden wegen WindowsFeature
 Für Windows 10: Eventuell per Enable-WindowsOptionalFeature
#>

# Fügt das xWebAdministration-Modul per DSC hinzu
configuration InstallxWebAdministration
{
    param([String]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $Computername
    {
        # xWebAdministration auf dem Node hinzufügen
        Script InstallxWebAdminResource
        {
            GetScript = { @{Result = $true} }

            TestScript = {
                (Get-InstalledModule -Name xWebAdministration -ErrorAction Ignore) -ne $null
            }

            SetScript = {
                Install-Module -Name xWebAdministration -Force
            }
        }
    }
}

InstallxWebAdministration -Computername Localhost

# Start-DSCConfiguration -Path .\InstallxWebAdministration -Wait -Verbose -Force

# Richtet die Website mit WebApp ein
configuration PoshWebAppSetup
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xWebAdministration

    node $AllNodes.NodeName
    {
        # Alle Webserver bezogenen Features hinzufügen
        $i = 0
        foreach($Feature in $Node.FeatureListe)
        {
            $i++
            WindowsFeature "WebFeature$i"
            {
                Ensure = "Present"
                Name = $Feature
            }
        }

        # App Pool einrichten
        xWebAppPool PoshAppPool
        {
            Ensure = "Present"
            Name = $Node.WebAppPoolName
            State  = "Started"
        }

        # Website-Verzeichnis anlegen
        File WebsiteDir
        {
            Ensure = "Present"
            DestinationPath = $Node.WebSitePath
            Type = "Directory"
        }

        xWebSite PoshWebSite
        {
            Ensure = "Present"
            Name = $Node.WebsiteName
            BindingInfo = MSFT_xWebBindingInformation
            {
                Protocol = "Http"
                Port = $Node.Port
            }
            PhysicalPath = $Node.WebsitePath
            State = "Started"
            DependsOn = @("[xWebAppPool]PoshAppPool","[File]WebsiteDir")
        }

        xWebApplication PoshWebApp
        {
            Ensure = "Present"
            Name = $Node.WebAppName
            WebSite = $Node.WebsiteName
            WebAppPool = $Node.WebAppPoolName
            PhysicalPath = $Node.WebSitePath
        }

        File DefaultHtml
        {
            Ensure = "Present"
            Type = "File"
            DestinationPath = $Node.DefaultHtmlPath
            SourcePath = $Node.DefaultHtmlSourcePath
        }

        File DefaultBitmap
        {
            Ensure = "Present"
            Type = "File"
            DestinationPath = $Node.DefaultImagePath
            SourcePath = $Node.DefaultImageSourcePath
        }
    }
}

$ConfigData = @{

    AllNodes = @(
    @{
        FeatureListe = @("Web-Server", "Web-Mgmt-Tools", "Web-Default-Doc",
           "Web-Dir-Browsing", "Web-Http-Errors", "Web-Static-Content",
           "Web-Http-Logging", "Web-Stat-Compression", "Web-Filtering",
           "Web-CGI", "Web-ISAPI-Ext", "Web-ISAPI-Filter")
      NodeName="localhost"
      WebAppName = "PoshApp"
      WebAppPoolName = "PoshAppPool"
      WebSiteName = "PoshWebSite"
      WebSitePath = "C:\inetpub\wwwroot\poshsite"
      WebApplicationName = "PoshWebApp"
      WebVirtualDirectoryName = "PoshApp"
      Port = 8008
      DefaultHtmlPath = "C:\inetpub\wwwroot\poshsite\default.html"
      DefaultHtmlSourcePath = "C:\inetpub\wwwroot\iisstart.htm"
      DefaultImageSourcePath = "C:\inetpub\wwwroot\iis-85.png"
      DefaultImagePath = "C:\inetpub\wwwroot\poshsite\iis-85.png"
    }
    )
}
  
PoshWebAppSetup -ConfigurationData $ConfigData

# Start-DSCConfiguration -Path .\PoshWebAppSetup -Wait -Verbose -Force
