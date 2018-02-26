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
# Enum-Werte müssen nicht mit dem Enumtypnamen "qualifiziert" werden
$User1.UserType = "Domain"
$User1.UserName = "Tadäus Zwackelmann"
$User1