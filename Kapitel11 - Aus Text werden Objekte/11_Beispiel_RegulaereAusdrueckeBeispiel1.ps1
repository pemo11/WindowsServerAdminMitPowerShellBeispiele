<#
 .Synopsis
Beispiel Nr. 1 für das Zerlegen von Namen mit Hilfe eines regulären Ausdrucks
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

foreach($Name in $ServerNamen -split "`n")
{
    [void]($Name -match $Muster)
    [PSCustomObject]@{
                        Server = $Matches[1]
                        Id = $Matches[2]
                    }
}
