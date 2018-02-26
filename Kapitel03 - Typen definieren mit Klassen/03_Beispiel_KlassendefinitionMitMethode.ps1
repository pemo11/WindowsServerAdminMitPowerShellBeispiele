<#
 .Synopsis
 PowerShell-Klasse mit einer Methoden-Definition
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

}
 
$User1 = [UserData]::new()
# Wie bei jedem Methodenaufruf ein Paar runder Klammern nicht vergessen
$User1.GetDaysSinceLastLogon()
