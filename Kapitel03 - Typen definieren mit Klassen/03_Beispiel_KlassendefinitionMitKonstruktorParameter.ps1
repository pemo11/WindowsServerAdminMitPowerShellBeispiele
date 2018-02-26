<#
 .Synopsis
 PowerShell-Klasse mit Konstruktor und einem Parameter
#>

class UserData
{
  [int]$Id

  UserData([Int]$UserId)
  {
    $this.Id = $UserId
  }
}

# Dem new-Konstruktor muss eine Zahl übergeben werden
$User1 = [UserData]::new(123)
$User1.Id