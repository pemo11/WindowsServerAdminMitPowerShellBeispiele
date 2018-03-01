<#
 .Synopsis
 Typ-Erweiterung mit einem CustomObject
 .Description
 Keine echte Typ-Erweiterung, da an den PowerShell-Typ PSCustomObject für die Dauer
 der Ausgabe eine Eigenschaft mit dem Namen P2 angehängt wird
#>

$obj = [PsCustomObject]@{P1=100}

# So einfach geht es leider nicht
# $obj.P2 = 200

# Das Hinzufügen eines Members geht nur über Add-Member 
$obj | Add-Member -MemberType NoteProperty -Value 200 -Name P2
$obj 