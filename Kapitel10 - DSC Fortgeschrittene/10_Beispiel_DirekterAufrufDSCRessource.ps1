<#
 .Synopsis
Direkter Aufruf einer Set-, Test- oder Get-Methode einer DSC-Ressource
#>

# Die Angabe des ModuleName ist obligatorisch
Invoke-DscResource -Name File -Method Test `
    -Property @{DestinationPath = "C:\PoshDir";Ensure="Absent"} `
    -ModuleName PSDesiredStateConfiguration

# Die umständlichere Methode über den Aufruf einer WMI-Methode per Invoke-CimMethod im Rahmen einer CIM-Session

# Setzt das Vorhandensein einer Mof-Datei voraus

$Mof = @"

instance of MSFT_FileDirectoryConfiguration
    {
        ResourceID = "[File]file";
        Type = "Directory";
        DestinationPath = "C:\\PoshDir";
        ModuleName = "PSDesiredStateConfiguration";
        SourceInfo = "::3::5::File";
        ModuleVersion = "1.0";
        ConfigurationName = "PoshDir";
    };

    instance of OMI_ConfigurationDocument
    {
        Version="2.0.0";
        MinimumCompatibleVersion = "1.0.0";
    };
"@

$Mof | Set-Content -Path "C:\FileResource.mof"

$Namespace  = "root/Microsoft/Windows/DesiredStateConfiguration"
$ClassName  = "MSFT_DSCLocalConfigurationManager"
$CimClass   = Get-CimClass -Namespace $Namespace -ClassName $ClassName
 
$MofData = Get-Content -Path  "C:\FileResource.mof"
$TotalSize = [System.BitConverter]::GetBytes($MofData.Length + 4)
$DataInUint8Format = $TotalSize + [System.Text.Encoding]::UTF8.GetBytes($MofData)
 
$Params = @{
    ModuleName       = "PSDesiredStateConfiguration"
    resourceProperty = $DataInUint8Format
    ResourceType     = "MSFT_FileDirectoryConfiguration"
}
 
# Anlegen der CIM-Session
$CIMSession = New-CimSession -ComputerName Localhost
 
# Aufruf der Methode ResourceTest
Invoke-CimMethod -CimClass $CimClass -MethodName ResourceTest -Arguments $Params -CimSession $CIMSession -Verbose

# Entfernen der CIM-Session
Get-CimSession | Remove-CimSession