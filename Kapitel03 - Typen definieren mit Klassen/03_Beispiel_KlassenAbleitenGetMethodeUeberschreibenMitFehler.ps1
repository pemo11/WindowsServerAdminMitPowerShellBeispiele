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
    return "Typename = $($this.GetType().FullName)"
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

$user1 = [DomainUserData]::new(100)
$User1.DomainUserName = "Hannes P."
$user1.GetType()

