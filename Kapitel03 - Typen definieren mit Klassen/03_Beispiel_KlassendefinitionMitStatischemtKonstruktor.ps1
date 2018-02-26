<#
 .Synopsis
 PowerShell-Klasse mit einem statischen Konstruktor
#>

class UserData
{
  static[int]$InstanceCount
  
  static UserData()
  {
    [UserData]::InstanceCount++
  }
}

# Ein statischer Konstruktor wird bereits ausgeführt, wenn die Klasse nur angesprochen wird

# Ergibt bereits 1, obwohl nichts (aktiv) passiert ist
[UserData]::InstanceCount