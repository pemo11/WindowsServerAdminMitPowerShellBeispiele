<#
 .Synopsis
 Ein "Hallo, Welt"-Beispiel für DSC
#>

configuration HalloDSC
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration

    node localhost
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
