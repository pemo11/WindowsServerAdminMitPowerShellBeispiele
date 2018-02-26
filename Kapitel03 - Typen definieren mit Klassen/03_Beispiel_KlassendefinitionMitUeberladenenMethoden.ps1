<#
 .Synopsis
 PowerShell-Klasse mit einer überladenen Methoden-Definition
#>

enum UserType
{
    Domain
    Local
}

class UserData
{
    [UserType]$UserType

    UserData()
    {
        $this.UserType = "Domain"
    }

    UserData([UserType]$UserType)
    {
        $this.UserType = $UserType
    }

    [int]GetDaysSinceLastLogon()
    {
        return 42
    }

    [int]GetDaysSinceLastLogon([DateTime]$Datum)
    {
        return ((Get-Date)-$Datum).Days
    }

}

# Eine überladene Methode kann pro Überladung mit unterschiedlichen Argumenten ausgeführt werden
$User1 = [UserData]::new()
# Variante 1
$User1.GetDaysSinceLastLogon()
# Variante 2
$DatumsWert = Get-Date 1.1.2018
$User1.GetDaysSinceLastLogon($DatumsWert)
