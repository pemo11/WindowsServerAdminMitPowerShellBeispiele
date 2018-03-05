<#
 .Synopsis
 Umgang mit Konfigurationsdaten bei DSC - Beispiel 1
#>

configuration ConfigdatenBeispiel1
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node $AllNodes.NodeName
  {
    Log ConfigTest
    {
      Message = "Erstelle Verzeichnis {0} auf Node: {1}" -f $Node.VerzPfad, $NodeName
    }

    File TestDir
    {
      Ensure  = "Present"
      DestinationPath = $Node.VerzPfad
      Type = "Directory"
    }

    File TestFile
    {
      Ensure  = "Present"
      DestinationPath = Join-Path -Path $Node.VerzPfad -ChildPath $Node.DateiName
      Type = "File"
      Contents = "Alles mit DSC!"
    }
  }
}

$ConfigData = @{
  AllNodes = @(
    @{
      NodeName = "localhost"
      Verzpfad = "C:\HalloDSC"
      DateiName = "DSC01.txt"
    }
  )
}
ConfigdatenBeispiel1 -ConfigurationData $ConfigData