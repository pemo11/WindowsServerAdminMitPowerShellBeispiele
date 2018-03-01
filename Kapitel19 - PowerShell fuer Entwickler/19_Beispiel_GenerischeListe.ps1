<#  .Synopsis
    Generische Listen
#> 

class UserData
{
    [Int]$Id
    [String]$Name
} 

$UserListe = New-Object -TypeName System.Collections.Generic.List[`UserData] 

# Geht
$UserListe.Add((New-Object -TypeName UserData -Property @{Id=1000;Name="PemoAdmin"}))

# Geht nicht
$UserListe.Add("1234")

$UserListe