$CustomResourcePfad = "E:\PoshSkripte\DSC_EigeneResource"
$DSCModulPfad = "C:\Program Files\WindowsPowerShell\DscService\Modules"
$PSModulPfad = "C:\Program Files\WindowsPowerShell\Modules"

$ModulVersion = "1.0"

$ModulName = [IO.Path]::GetFileNameWithoutExtension((dir -Path $CustomResourcePfad -Filter *.psd1).Name)

$TmpPfad = Join-Path -Path $env:temp -ChildPath PSCustomResource

if (Test-Path -Path $TmpPfad) 
{
    rd $TmpPfad -Recurse –Force
}

# Temporäres Verzeichnis anlegen
md $TmpPfad | Out-Null

# Modul-Dateien in das Modules-Verzeichnis kopieren

$PSModulResourcePfad = Join-Path -Path $PSModulPfad -ChildPath "$ModulName\$ModulVersion"

Copy $CustomResourcePfad\*.psm1, $CustomResourcePfad\*.psd1 $PSModulResourcePfad –Force

# Modul-Dateien nach Temp kopieren

Copy $CustomResourcePfad\*.psm1, $CustomResourcePfad\*.psd1 $TmpPfad

# Zip-Datei erstellen
$DestinationPath = "{0}\{1}_{2}.zip" -f $DSCModulPfad, $ModulName, $ModulVersion

# Wichtig: Die Zip-Datei enthaelt keine Hierarchie, sondern die Moduldateien direkt
Compress-Archive -Path $TmpPfad\* -DestinationPath $DestinationPath –Force

# Checksum-Datei erstellen
New-DscChecksum -Path $DSCModulPfad -Force -Verbose
