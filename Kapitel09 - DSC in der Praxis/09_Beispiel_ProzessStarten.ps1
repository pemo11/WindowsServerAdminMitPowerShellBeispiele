<#
 .Synopsis
 Einen Prozess starten per DSC
 .Notes
 Wie üblich keine "sichtbaren" Prozesse, also nur Konsolenprogramme
#>

configuration StartProcessBeispiel
{

  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node $AllNodes.Nodename
  {
    WindowsProcess DirExec
    {
       Ensure = "Present"
       Arguments = $Node.CmdLineArgs
       Path = $Node.CmdPath
       StandardOutputPath = $Node.StandardOutputPath
    }
  }
}


$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "localhost"
            CmdLineArgs = "/c dir C:\*.ps1 /s"
            CmdPath = "C:\Windows\System32\Cmd.exe"
            StandardOutputPath = "C:\CmdOutput.txt"
        }
    )

}

StartProcessBeispiel -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\StartProcessBeispiel -Wait -Verbose -Force