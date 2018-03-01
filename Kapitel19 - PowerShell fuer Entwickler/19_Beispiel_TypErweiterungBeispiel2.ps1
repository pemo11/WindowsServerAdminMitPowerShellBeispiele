<#
 .Synopsis
 Typ-Erweiterung mit einem CustomObject
#>

$obj = [PsCustomObject]@{P1=100}

# So einfach geht es leider nicht
# $obj.P2 = 200

# Das Hinzufügen eines Members geht nur über Add-Member 
$obj | Add-Member -MemberType NoteProperty -Value 200 -Name P2
$obj 