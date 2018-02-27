<#
 .Synopsis
 Ein "Hallo, Welt"-Beispiel für DSC mit Konfigurationsdaten
#>

configuration HalloDSC
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.Nodename
    {
        # Anlegen eines Verzeichnisses
        File TestDir
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshSkripte"
            Type = "Directory"
        }

        # Anlegen einer Datei
        File TestFile
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshSkripte\Test.ps1"
            Type = "File"
            Contents = "`"Die aktuelle Uhrzeit: `$(Get-Date -Format t)`""
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "Server1"
            Ps1Content = "`"Heute ist `$(Get-Date -Format dddd), der `$(Get-Date -Format dd) te um `$(Get-Date -Format t).`""
         }
         @{
            NodeName = "Server2"
            Ps1Content = "`"Heute ist `$(Get-Date -Format dddd), der `$(Get-Date -Format dd) te um `$(Get-Date -Format t).`""
         }
         @{
            NodeName = "Server3"
            Ps1Content = "`"Heute ist `$(Get-Date -Format dddd), der `$(Get-Date -Format dd) te um `$(Get-Date -Format t).`""
         }
      )
}

HalloDSC -ConfigurationData $ConfigData

