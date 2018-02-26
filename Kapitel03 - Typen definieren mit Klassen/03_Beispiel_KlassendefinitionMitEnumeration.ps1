<#
 .Synopsis
 Definition einer Klasse mit einem Enumerations-Member
#>

enum UserType
{
    Domain
    Local
}

class UserData
{
    [String]$UserName
    Static[Int]$Index
    [UserType]$UserType
}

$User1 = [UserData]::new()
# Enum-Werte m�ssen nicht mit dem Enumtypnamen "qualifiziert" werden
$User1.UserType = "Domain"
$User1.UserName = "Tad�us Zwackelmann"
$User1