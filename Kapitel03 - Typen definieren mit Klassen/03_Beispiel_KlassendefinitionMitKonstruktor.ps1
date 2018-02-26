<#
 .Synopsis
 Definition einer Klasse mit einem Konstruktor
#>

enum UserType
{
    Domain
    Local
}

# Der Konstruktor ist eine Methode ohne Rückgabetyp, die den Namen der Klasse trägt
class UserData
{
    [String]$UserName
    Static[Int]$Index
    [UserType]$UserType
    [Int]$Id

    UserData()
    {
        [UserData]::Index++
        $this.Id = [UserData]::Index
    }
}

# Der Wert der Id-Eigenschaft ist 1
$User1 = [UserData]::new()
$User1.Id