<#
 .Synopsis
 Typ-Erweiterung per Update-TypeData
 .Description
 Erweitert wird der Type System.IO.FileInfo um eine Eigenschaft Comment, welche den 
 Inhalt des Synopsis-Teils aus der Hilfe enthält
#> 

$SB = {
    if ($this.Extension -eq ".Ps1")
    {
        (Get-Help -Name $this.FullName).Synopsis
    }
} 

# Der Typ System.IO.FileInfo erhält eine weitere ScriptProperty
Update-TypeData -TypeName System.IO.FileInfo `
 -MemberName Comment -MemberType ScriptProperty -Value $SB

 # Ausprobieren, ob bei Ps1-Datei in der Spalte Comment etwas ausgegeben wird
Get-ChildItem $env:userprofile\Documents\WindowsPowerShell | 
  Select-Object Name, Comment 