<#
 .Synopsis
 Bereitstellen der DSC-Ressource cPoshProfile
 .Notes
 Sowohl im Module-Verzeichnis als auch für Pull Server-Betrieb
#>

$DSCModulPfad = "C:\Program Files\WindowsPowerShell\DscService\Modules"
$PSModulPfad = "C:\Program Files\WindowsPowerShell\Modules"
$ModulName = "cPoshProfile"
$ModulVersion = "1.0"

$PoshProfileModulePfad =  (Join-Path -Path $PSModulPfad -ChildPath $ModulName)

# Modulverzeichnis anlegen
mkdir $PoshProfileModulePfad -ErrorAction Ignore

# Dateien in Module-Verzeichnis kopieren
Copy-Item -Path .\cPoshProfile.psd1, .\cPoshProfile.psm1 -Destination $PoshProfileModulePfad -Force

# Modul-Dateien in das DSC-Verzeichnis kopieren

$PSModulResourcePfad = Join-Path -Path $DSCModulPfad -ChildPath "$ModulName`_$ModulVersion.zip"


# Zip-Datei erstellen
# Wichtig: Das Zip-Archiv enthaelt keine Hierarchie, sondern die Moduldateien direkt
Compress-Archive -Path $PoshProfileModulePfad\* -DestinationPath $PSModulResourcePfad -Force

# Checksum-Datei erstellen
New-DscChecksum -Path $PSModulResourcePfad -Force -Verbose