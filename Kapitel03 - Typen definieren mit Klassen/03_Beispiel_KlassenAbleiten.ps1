<#
 .Synopsis
 Abgeleitete Klassen
#>

class UserData
{
    [Int]$UserId

    UserData()
    {
        $this.UserId = -1
    }

    UserData([Int]$UserId)
    {
        $this.UserId = $UserId
    }

}

# Diese Klasse leitet sich von der Klasse UserData ab
class DomainUserData : UserData
{
    [String]$DomainUserName
}

$DomUser1 = [DomainUserData]::new()
# Die Eigenschaft UserId ist in der Klasse UserData definiert
$DomUser1.UserId