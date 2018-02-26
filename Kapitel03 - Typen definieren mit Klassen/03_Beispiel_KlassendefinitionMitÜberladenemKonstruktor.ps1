<#
 .Synopsis
 PowerShell-Klasse mit einem überladenden Konstruktor - einmal mit und einmal ohne Parameter
#>

class UserData
{
    [int]$Id

    UserData ()
    {
        $this.Id = -1
    }

    UserData ([Int]$UserId)
    {
        $this.Id = $UserId
    }
} 

# Ein Objekt kann jetzt auf zwei Weisen gebildet werden

$User1 = [UserData]::new()

$User2 = [UserData]::new(1000)

$User1
$User2
