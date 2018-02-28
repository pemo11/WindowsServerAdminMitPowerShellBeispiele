<#
 .Synopsis
Beispiel Nr. 3 für das Zerlegen von Namen mit Hilfe eines regulären Ausdrucks
#>

$ServerNamen = "
Server123
PC-077
Rack[99]
Server/489
PC456
Server_A100
"

# Etwas kurios: Damit es funktioniert, muss das Carriage Return-Zeichen 13 entfernt werden
$ServerNamen = $ServerNamen -replace "`r",""

# $ServerNamen | Format-Hex

$Muster = "^([a-z]+)[-[/_]*([a-z0-9]+)$"

# Die RegeExOptions Multiline und IgnoreCase müssen gesetzt werden
[Regex]::Matches($ServerNamen, $Muster, "Multiline,IgnoreCase") | 
 Select-Object @{n="Name";e={$_.Groups[1]}}, @{n="ID";e={$_.Groups[2]}}
