<#
 .Synopsis
 Definition einer Klasse mit einem Feld bzw. einer Eigenschaft
#>

# Eine Eigenschaft ist nur eine Variable, die innerhalb der Klassendefinition steht
# Der Datentyp ist optional
class UserData
{
    [String]$UserName
}

# Um die Eigenschaft mit einem Wert belegen zu können, wird ein Objekt benötigt
$User1 = [UserData]::new()
$User1.UserName = "Matthäus Finkenacker"