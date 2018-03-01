<#
.Synopsis
Assembly-Bibliothek anlegen
.Description
Eine Assembly-Bibliothek als Dll-Datei per Add-Type-Cmdlet anlegen
#> 

$CSCode = @'
using System; using System.Management;

namespace PoshBuch
{

 public class PsInfo
 {
    public string OSVersion { get; set; }
    public string OSCaption { get; set; }
    public long RAM { get; set; }
 } 
 
 public static class PsSystem
 {
    public static PsInfo GetPsInfo()
    {
        // Simuliert eine echte Abfragen per WMI
        string osVersion = "18123.1240";
        string osCaption = "Windows 11 SP2";
        long pcMemory = 549755813888;
        return new PsInfo { OSVersion = osVersion, OSCaption = osCaption, RAM=pcMemory};
    }
 }
} 
'@

# Die C#-Typdefinition in eine Assembly-Datei kompilieren
Add-Type -TypeDefinition $CSCode -OutputType Library -OutputAssembly PsInfoLib.dll

# Assembly-Datei erneut laden
Add-Type -Path .\PsInfoLib.dll

# Typ aus der Assemblydatei verwenden
[PoshBuch.PsSystem]::GetPsInfo()