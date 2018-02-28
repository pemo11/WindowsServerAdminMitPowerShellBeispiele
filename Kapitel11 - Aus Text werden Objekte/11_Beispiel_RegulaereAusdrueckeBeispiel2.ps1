<#
 .Synopsis
 Beispiel Nr. 2 für das Zerlegen von Namen mit Hilfe eines regulären Ausdrucks
#>

$ServerNamen = "
Server123
PC-077
Rack[99]
Server/489
PC456
Server_A100
"
$Muster = "^([a-z]+)[-[/_]*([a-z0-9]+)"

$ServerNamen -split "`n" | 
 Select-String -Pattern $Muster | 
 Select-Object @{n="Name";e={$_.Matches[0].Groups[1]}}, @{n="Nr";e={$_.Matches[0].Groups[2]}}