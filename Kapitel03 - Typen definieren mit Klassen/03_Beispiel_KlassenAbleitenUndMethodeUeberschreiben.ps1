<#
 .Synopsis
 Überschreiben einer Methode einer Basisklasse
 .Notes
 Dieses Beispiel funktioniert nicht - der PowerShell-Hostprozess stürzt ab
#>

class UserData
{
    [Int]$UserId

    UserData([Int]$UserId)
    {
        $this.UserId = $UserId
    }

    # Diese Methode wird überschrieben, da sie in der Basisklasse von UserData, 
    # der Klasse Object, von der sich alle (!) Klassen ableiten, definiert ist
    [string]ToString()
    {
        return "UserID=$($this.UserId)"
    }
}

$User1 = [UserData]::new(1000)

# Durch das Einsetzen in eine Zeichenkette wird die ToString()-Methode ausgeführt
"$User1"