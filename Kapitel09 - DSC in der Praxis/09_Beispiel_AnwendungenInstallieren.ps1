<#
 .Synopsis
 Installation einer Anwendung per Package-Ressource
 .Notes
 Setzt voraus, dass sich die Installationsprogramm bereits auf dem Node-Client befinden
 In diesem Beispiel im Verzeichnis C:\Packages
 Pro Node kann in den Konfigurationsdaten festgelegt werden, welche Packages installiert werden
#>

configuration SetupPackages
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.Nodename
    {
        foreach($Package in $Node.ProductList)
        {
            $PackageData = $ConfigurationData.PackageList[$Package]

            Package $PackageData.Name
            {
                Ensure = "Present"
                Name = $PackageData.FullName
                ProductId = $PackageData.ProductId
                Path = $PackageData.Path
                Arguments = $PackageData.InstallArguments
            }
        }
    }
}

$ConfigData = @{

    PackageList = @{

        "SevenZip" = @{
            Name = "7Zip"
            Version = ""
            FullName = "7 Zip 16.04 (x64)"
            ProductId = ""
            Path = "C:\Packages\7Zip\7z1604-x64.exe"
            InstallArguments = "/S"
        }
        
        "NotepadPP" = @{
            Name = "NotepadPP"            
            Version = ""
            FullName = "Notepad++ (64-bit x64)"
            ProductId = ""
            Path = "C:\Packages\NotepadPlus\Npp.7.5.4.installer.x64.exe"
            InstallArguments = "/S"
        }
        
        "ConEmu" = @{
            Name="ConEmu"
            Version = ""
            FullName = "ConEmu 180206.x64"
            ProductId = "FAD878D0-AB06-400F-B2CE-C6BE3AE0B226"
            Path = "C:\Packages\ConEmu\ConEmuSetup.180206.exe"
            InstallArguments = "/p:x64 /quiet /norestart"
        }

        "VWMWareTools" = @{
            Name="VMWareTools"
            Version = ""
            FullName = "VMWare Tools"
            ProductId = "150A78E4-A6BA-4FA5-BE15-D2C4AB5E0AAA"
            ProductId2 = "507F5BFC-6DFE-43CF-A552-DABE868FCDFE"
            Path = "C:\Packages\VMWareTools\Setup.exe"
            InstallArguments = "/S /v `"/qn REBOOT=R`""
        }

        "SQLServerExpress" = @{
            Name = "SQLExpress"
            Version = ""
            ProductId = ""
            Path = "C:\Packages\SQLServerExpress\SQLEXPR_x64_ENU.exe"
            InstallArguments = "/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=SQLEXPRESS /INSTANCENAME=SQLEXPRESS /UPDATEENABLED=FALS"
            MsiArguments = ""
        }

    }

    AllNodes = @(
        @{
            NodeName = "W2016X"
            ProductList = @("ConEmu", "NotepadPP")
        }
    )
}

SetupPackages -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::New("Administrator", $PwSec)


# Start-DSCCOnfiguration -Path .\SetupPackages -Credential $PSCred -Verbose -Wait -Force