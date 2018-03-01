<# 
.Synopsis
Debuggen von Schleifen
#>

$Ps1Pfad = Join-Path -Path $PSScriptRoot -ChildPath Zählskript.ps1
.$Ps1Pfad

<#
function f1
{
    param([Int]$Max)
    $i = 0
    while($i -lt $Max)
    {
        $i++
        "While-Durchlauf Nr. $i"
    }
}
#>

f1 -Max 5

1..10 | ForEach-Object {
 "ForEach-Durchlauf Nr. $_"
}

for($i = 0; $i -lt 10; $i++)
{
 "For-Durchlauf Nr. $i"
}

$i = 0 
do
{
    $i++
     "Do-Durchlauf Nr. $i"

} until ($i -eq 11)