<#
 .Synopsis
 Zip-Datei auspacken der DSC
 .Notes
 Muss mit Administratorberechtigungen ausgef�hrt werden
#>

configuration ArchiveRessourceBeispiel
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node $AllNodes.Nodename
  {
    # Temp-Verzeichnis anlegen, wenn nicht vorhanden
    File TempDir
    {
      Ensure = "Present"
      DestinationPath = $Node.TempPath
      Type = "Directory"
    }

    # Per Script-Ressource Zip-Datei herunterladen
    Script DownloadZip
    {
      # muss $false zurueckgegeben, damit die SetScript-Aktion bei Ensure=Present ausgefuerhrt wird
      TestScript = { (Test-Path -Path $using:Node.ZipPath) } 

      # Reiner Formalismus - der Rueckgabewert muss eine Hashtable mit einem Result-Schluessel sein
      GetScript = {
        @{Result = ""}
      }
      SetScript = {
        Invoke-WebRequest -Uri $using:Node.ZipUrl -OutFile $using:Node.ZipPath
      }
    }

    Archive Ps1Zip
    {
        Ensure = "Present"
        Path = $Node.ZipPath
        Destination = $Node.Ps1Path
        Force = $true
        DependsOn = "[Script]DownloadZip"
    }
  }
}

$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "localhost"
            TempPath = "C:\Temp"
            ZipPath = "C:\Temp\Ps1Skripte.zip"
            Ps1Path = "C:\Ps1Skripte"
            ZipUrl = "http://www.activetraining.de/Downloads/Ps1Skripte.zip"
        }
    )
}


ArchiveRessourceBeispiel -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\ArchiveRessourceBeispiel -Wait -Verbose -Force