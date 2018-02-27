<#
 .Synopsis
 Ein "Hallo, Welt"-Beispiel für DSC mit einer externen Ressource
#>

configuration HalloDSC
{
    param([String[]]$Computername)

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    # Setzt voraus, dass xSmbShare per Install-Module hinzugefügt wurde
    Import-DscResource -ModuleName xSmbShare

    node $Computername
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

        # Geht nicht auf Windows 7 und Windows Server 2008 R2
        xSmbShare TestShare
        {
            Ensure = "Present"
            Name = "TestShare"
            Path = "C:\PoshSkripte"
            Description = "Nur ein Test"
        }

    }
}

HalloDSC -Computername Server1, Server2, Server3