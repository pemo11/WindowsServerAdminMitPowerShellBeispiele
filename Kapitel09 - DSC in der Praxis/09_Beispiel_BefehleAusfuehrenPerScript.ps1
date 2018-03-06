<#
 .Synopsis
 Ein Beispiel für die Script-Ressource
#>

configuration ScriptBeispiel
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node $AllNodes.NodeName
  {
      File DownloadDir
      {
        Ensure = "Present"
        DestinationPath = "C:\Temp"
        Type = "Directory"
      }

      Script DownloadZip
      {
        # muss $false zurueckgegeben, damit SetScript ausgeführt wird
        # $env:temp geht nicht?
        TestScript = {
                Test-Path -Path (Join-Path -Path $using:Node.LocalPath -ChildPath $using:Node.LocalFile)
        }

        # Rückgabewert muss Hashtable sein - Result-Wert spielt keine Rolle?
        GetScript = {
            @{Result = $true}
        }

        SetScript = {
          # Geht nicht
          # $DownloadUrl = $Node.DownloadUrl
          $DownloadUrl = $using:Node.DownloadUrl
          $LocalZipPath = Join-Path -Path $using:Node.LocalPath -ChildPath $using:Node.LocalFile
          Write-Verbose "*** Downloading $DownloadUrl nach $LocalZipPath ***"
          try
          {
              Invoke-WebRequest -Uri $DownloadUrl -OutFile $LocalZipPath
          }
          catch
          {
              Write-Verbose "Fehler beim Download: $_"
          }  
        }
      }
  }
}

$ConfigData = @{

    AllNodes = @(
      @{
        NodeName = "W2016X"
        DownloadUrl = "http://www.activetraining.de/Downloads/Ps1Skripte.zip"
        LocalPath = "C:\Temp"
        LocalFile = "PoshSkripte123.zip"
     }
    )
}
  
ScriptBeispiel -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::New("Administrator", $PwSec)

# Start-DscConfiguration -Path .\ScriptBeispiel -Wait -Verbose -Force -Credential $PSCred