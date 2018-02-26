<#
 .Synopsis
 PowerShell-Klasse mit einer statischen Methode
#>

class UserData
{
    [Int]$UserId

    UserData([Int]$UserId)
    {
        $this.UserId = $UserId
    }

    static[UserData]GetNewUserData()
    {
        return [UserData]::new(-1)
    }
}

# Eine statische Methode wird direkt über die Klasse aufgerufen
$User1 = [UserData]::new(1000)
$User1.UserId

[UserData]::GetNewUserData()