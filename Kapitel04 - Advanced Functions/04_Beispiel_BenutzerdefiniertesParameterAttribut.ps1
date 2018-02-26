<#
 .Synopsis
 Benutzerdefiniertes Parameter-Attribut
#>

# Diese Klassendefinition definiert ein neues Validierungsattribut
class ValidateWeekendAttribute : System.Management.Automation.ValidateArgumentsAttribute
{

    [void]Validate([Object]$Value, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics)
    {
        if (-not (Get-Date -Date $Value -ErrorAction Ignore))
        {
            throw "Parameter besitzt ein ungültiges Datum"
        }

        [DayOfWeek]$w = (Get-Date -Date $Value).DayOfWeek
        if ($w -eq "Saturday" -or $w -eq "Sunday")
        {
            throw "Datum darf weder Samstag noch Sonntag sein"
        }
    }
}

# Eine Function verwendet das neue Attribut
function Test-Workday
{
    param([ValidateWeekendAttribute()][String]$Date)
    "Alles klar mit $Date"
}

# Der folgende Aufruf geht gut
$Datum = Get-Date -Date 1.1.2018
Test-Workday -Date $Datum

# Der folgende Aufruf geht nicht gut
$Datum = Get-Date -Date 31.12.2017
Test-Workday -Date $Datum

