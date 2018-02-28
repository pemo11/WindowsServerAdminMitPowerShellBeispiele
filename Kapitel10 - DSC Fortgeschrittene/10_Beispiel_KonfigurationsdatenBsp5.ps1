<#
 .Synopsis
 Umgang mit Konfigurationsdaten bei DSC - Beispiel 5
#>

configuration ConfigdatenBeispiel5
{
    param([String[]]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $Computername
    {
        foreach($Datei in $ConfigurationData.Dateien)
        {
            File "Datei$($Datei.Nr)"
            {
                Ensure  = "Present"
                DestinationPath = $Datei.Pfad
                Type = "File"
                Contents = $Datei.Inhalt
            }
        }
    }
}

$ConfigData = @{

    Dateien  = @(
        @{
            Nr = 1
            Pfad = "C:\DSCTest1"
            Inhalt = "Alles klar mit DSC!"
        }
        @{
            Nr = 2
            Pfad = "C:\DSCTest2"
            Inhalt = "Mit DSC geht alles klar!"
        }
    )

    AllNodes = @()

}

ConfigdatenBeispiel5 -ConfigurationData $ConfigData -Computername Localhost