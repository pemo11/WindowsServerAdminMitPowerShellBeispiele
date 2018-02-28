<#
 .Synopsis
 Beispiel für eine Composite Resource
 .Notes
 Mit WMF 5.0 wurde das Erstellen deutlich vereinfacht, da für die einzelnen Ressourcen, die
 Bestandteil einer Composite Ressource sein sollen, kein separates Modul mehr angelegt werden 
 muss.
 Die Erläuterungen im Buch beziehen sich noch auf den Stand von WMF 4.0
#>

configuration xHyperVSetup
{
    param([Parameter(Mandatory)][ValidateNotNullOrEmpty()][String[]]$VMName,
          [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$SwitchName,
          [String]$VHDParentPath
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xHyper-V

    # Ordner für Vhd-Datei anlegen
    File VHDFolder
    {
        Ensure = "Present"
        DestinationPath = $VHDParentPath
        Type = "Directory"
    }

    # Anlegen einer Parent-Vhd
    xVHD VMVhdParent
    {
      Ensure = "Present"
      Name = "ParentVhd"
      Path = $VHDParentPath
      MaximumSizeBytes = 64GB
      Generation = "Vhd"
      DependsOn = "[File]VhdFolder"
    }

    # Jede VM anlegen
    foreach ($Name in $VMName)
    {
      # Für jede VM eine Diff-Vhd anlegen
      xVHD "VHD$Name"
      {
        Ensure = "Present"
        Name = "$Name`_Vhd"
        Path = "xxx"
        DependsOn = @("[File]VHDFolder")
      }

      # Jetzt die VM anlegen
      xVMHyperV "VMachine$Name"
      {
        Ensure = "Present"
        Name = $Name
        VhDPath = (Join-Path -Path $VHDParentPath -ChildPath "$Name`_Vhd.vhd")
        SwitchName = $SwitchName
        StartupMemory = 1GB
        State = "Running"
        DependsOn = @("[xVHD]VHD$Name")
      }
    }
}

Configuration VMLabSetup
{
    xHyperVSetup HyperVSetup
    {
        VMName = "PoshKursVM1"
        SwitchName = "Standard"
        VHDParentPath = "E:\HyperV_VHD"
    }
}

VMLabSetup