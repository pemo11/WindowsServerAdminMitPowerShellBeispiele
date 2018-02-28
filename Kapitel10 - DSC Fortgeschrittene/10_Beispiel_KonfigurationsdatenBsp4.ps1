<#
 .Synopsis
 Umgang mit Konfigurationsdaten bei DSC - Beispiel 4
#>

configuration ConfigdatenBeispiel4
{
    param([String[]]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $Computername
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

    AllNodes = @()

}

ConfigdatenBeispiel4 -ConfigurationData $ConfigData -Computername Server1, Server2, Server3