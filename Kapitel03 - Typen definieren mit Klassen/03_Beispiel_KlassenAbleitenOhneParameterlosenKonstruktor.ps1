<#
 .Synopsis
  Ableiten von einer Klasse, die keinen parameterlosen Konstruktor besitzt - geht bei 5.1 nicht
#>

class UserData
{
  [Int]$UserId

  <#
  UserData()
  {

  }
  #>

  UserData([Int]$UserId)
  {
    $this.UserId = $UserId
 }
}

class DomainUserData : UserData
{
  [String]$DomainUserName
}

# Geht nicht, da die Klasse UserData keinen parameterlosen Konstruktor besitzt
$DomainUser1 = [DomainUserData]::new()
$DomainUser1

# Die einfachste Lösung ist das Hinzufügen eines Konstruktors ohne Parameter