<#
 .Synopsis
Beispiel Nr. 1  - Zerlegen von Texten mit regulären Ausdrücken und dem match-Operator
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
