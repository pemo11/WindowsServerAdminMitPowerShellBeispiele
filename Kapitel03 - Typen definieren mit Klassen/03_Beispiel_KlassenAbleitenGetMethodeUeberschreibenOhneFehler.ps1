<#
 .Synopsis
 Überschreiben einer Get-Methode einer Basisklasse mit "Absturz"
#>

class UserData
{
    [Int]$UserId

  UserData()
  {
  }

  [Object]GetType()
  {
    return "Typename = $(([Object]$this).GetType().FullName)"
  }
}

class DomainUserData : UserData
{
  [String]$DomainUserName

  DomainUserData([Int]$UserId)
  {
    $this.UserId = $UserId
  }

}

# Diese Befehlsfolge wird korrekt ausgeführt
$User1 = [DomainUserData]::new(100)
$User1.DomainUserName = "Hannes P."
$User1.GetType()

