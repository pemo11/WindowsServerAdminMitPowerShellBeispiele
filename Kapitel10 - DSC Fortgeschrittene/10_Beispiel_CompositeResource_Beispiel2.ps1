<#
 .Synopsis
 Beispiel für eine Composite Resource
 .Notes
 Wie Beispiel 1 nur mit Konfigurationsdaten
 Es werden drei VMs auf dem Node angelegt und gestartet (Minimum 6GB, ansonsten nur 2 VMs starten)
#>

$ConfigData = @{

  AllNodes = @(
    @{
      NodeName = "HyperV1"
      VMName = @("PoshKurs1", "PoshKurs2", "PoshKurs3")
      SwitchName = "Standard"
      VhdParentPath = "C:\HyperV_VHD"
    }
  )
}

configuration xHyperVSetup
{
    param([Parameter(Mandatory)][ValidateNotNullOrEmpty()][String[]]$VMName,
          [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$SwitchName,
          [String]$VhdParentPath
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
        $VhdPath = Join-Path -Path $VHDParentPath -ChildPath $Name

        # Für jede VM ein Verzeichnis anlegen
        file "VhdDir$Name"
        {
          Ensure = "Present"
          DestinationPath = $VhdPath
          Type = "Directory"
        }

        # Für jede VM eine Diff-Vhd anlegen
        xVHD "Vhd$Name"
        {
          Ensure = "Present"
          Name = "$Name"
          MaximumSizeBytes = 64GB
          Path = $VhdPath
          DependsOn = @("[File]VHDFolder")
        }

      # Jetzt die VM anlegen
      xVMHyperV "VMachine$Name"
      {
        Ensure = "Present"
        Name = $Name
        VhdPath = (Join-Path -Path $VhdPath -ChildPath "$Name`.vhd")
        SwitchName = $SwitchName
        StartupMemory = 1GB
        State = "Running"
        DependsOn = @("[xVHD]VHD$Name")
      }
    }
}

configuration VMLabSetup2
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xHyper-V

    node $AllNodes.Nodename
    {
        xHyperVSetup HyperVSetup1
        {
          # Der Eigenschaft kann auch ein Array mit Namen übergeben werden
          VMName = $Node.VMName
          SwitchName = $Node.SwitchName
          VhdParentPath = $Node.VhdParentPath
        }
    }
}

VMLabSetup2 -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::new("Administrator", $PwSec)

Start-DSCConfiguration -Path .\VMLabSetup2 -Credential $PSCred -Wait -Verbose -Force