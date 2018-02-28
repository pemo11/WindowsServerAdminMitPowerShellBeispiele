<#
 .Synopsis
 Umgang mit Konfigurationsdaten bei DSC - Beispiel 3
#>

configuration ConfigdatenBeispiel3
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        File TestFile
        {
            Ensure  = "Present"
            DestinationPath = $Node.Dateipfad
            Type = "File"
            Contents = $ConfigurationData.DateiInhalt
        }

    }
}

$ConfigData = @{

    DateiInhalt = "Alles klar mit DSC!"

    AllNodes = @(
        @{
            NodeName = "*"
            Dateipfad= "C:\DSCTest.txt"
        }
        @{
            NodeName = "Server1"
        }
        @{
            NodeName = "Server2"
        }
    )
}

ConfigdatenBeispiel3 -ConfigurationData $ConfigData 