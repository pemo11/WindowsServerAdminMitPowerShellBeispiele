<#
.Synopsis
Generische Listen
.Description
Verwenden einer generischen Liste, die nur Werte eines bestimmten Typs aufnimmt
#> 

# Der spezielle Typ für die generische Liste
class UserData
{
    [Int]$Id
    [String]$Name
} 

# Eine generische Liste aus der .NET-Laufzeit anlegen für Werte vom Typ UserData
$UserListe = New-Object -TypeName System.Collections.Generic.List[`UserData] 

# Dieser Zugriff geht, da der Typ stimmt
$UserListe.Add((New-Object -TypeName UserData -Property @{Id=1000;Name="PemoAdmin"}))

# Dieser Zugriff geht nicht, da der Typ nicht stimmt
$UserListe.Add("1234")

$UserListe