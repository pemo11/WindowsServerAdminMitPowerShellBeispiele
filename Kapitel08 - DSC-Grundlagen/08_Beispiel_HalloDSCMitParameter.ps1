<#
 .Synopsis
 Ein "Hallo, Welt"-Beispiel für DSC mit einem Computername-Parameter
#>

configuration HalloDSC
{
    param([String[]]$Computername)

    Import-DscResource -ModuleName PSDesiredStateConfiguration

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
    }
}

HalloDSC -Computername Server1, Server2, Server3