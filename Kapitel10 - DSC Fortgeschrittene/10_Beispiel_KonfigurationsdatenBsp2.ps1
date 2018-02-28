<#
 .Synopsis
 Umgang mit Konfigurationsdaten bei DSC - Beispiel 2
#>

configuration ConfigdatenBeispiel2
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  Node ($AllNodes.Where{$_.Rolle -eq "Spezial"}).NodeName
  {
    File TestDir
    {
      Ensure  = "Present"
      DestinationPath = $Node.Pfad
      Type = "Directory"
    }
  }
}


$ConfigData = @{
    AllNodes = @(
      @{
        NodeName = "Localhost"
        NodeNr = 1
        Rolle = "Spezial"
        Pfad = "C:\LocalhostTest"
      }
      @{
        NodeName = "Server1"
        NodeNr = 2
        Rolle = "Spezial"
        Pfad = "C:\Server1Test"
      }
      @{
        NodeName = "Server2"
        NodeNr  = 3
        Rolle = "Allgemein"
      }
      @{
        NodeName = "Server3"
        NodeNr  = 4
        Rolle = "Spezial"
        Pfad = "C:\Server3Test"
    }
   )
  }
  

  ConfigdatenBeispiel2 -ConfigurationData $ConfigData