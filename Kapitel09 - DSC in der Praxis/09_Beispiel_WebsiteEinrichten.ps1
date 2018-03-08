<#
 .Synopsis
 Einrichten einer Website
 .Notes
 Setzt IIS voraus, beschränkt sich auf das Allernotwendigste
#>

Configuration SetupPoshWebsite
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration

    node $AllNodes.Nodename
    {
         # Website-Verzeichnis anlegen
        File PosSiteDir
        {
            Ensure = "Present"
            DestinationPath = $Node.WebsitePath
            Type = "Directory"
            SourcePath = $Node.SourcePath
            Recurse = $true
        }

        # Default-Website entfernen
        xWebsite Default
        {
            Ensure = "Absent"
            Name = "Default Web Site"
        }

        # Eine weitere IIS-Website anlegen
        xWebsite PoshSite
        {
            Ensure = "Present"
            Name = $Node.Sitename
            PhysicalPath = $Node.WebsitePath
            DefaultPage = $Node.DefaultPage
            State = "Started"
            DependsOn = "[File]PosSiteDir"
            # Nur dann erforderlich, wenn es Unterschiede zum Standard-Binding gibt
            BindingInfo = MSFT_xWebBindingInformation
            {
                Protocol              = "HTTP"
                Port                  = $Node.Port
                IPAddress             = "*"
            }
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            Sitename = "poshsite"
            WebsitePath = "C:\inetpub\wwwroot\poshsite"
            SourcePath = (Join-Path -Path $PSScriptRoot -ChildPath "Material\PoshsiteFiles")
            DefaultPage = "default.htm"
            Port = "88"
        }
    )
}

SetupPoshWebsite -ConfigurationData $ConfigData

Start-DscConfiguration -Path .\SetupPoshWebsite -Wait -Verbose -Force

$PortNr = $ConfigData.AllNodes[0].Port  
Start-Process -FilePath iexplore -ArgumentList "http://localhost:$PortNr"