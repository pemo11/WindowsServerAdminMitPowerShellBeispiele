<#
 .Synopsis
 Auflisten der Konstruktoren eines Typs
#>

# Ein PowerShell-Typobjekt über seinen Namen holen
$PSTypname = "System.Management.Automation.PSCredential"
$PSTyp = [psobject].Assembly.GetType($PSTypName)


# Variante A - etwas umständlich

$PSTyp.GetConstructors() | ForEach-Object -Begin { $i = 0} -Process {
    [PSCustomObject]@{
        Nr = "Konstruktor$((++$i))"
        Parameter = (($_.GetParameters() | ForEach-Object {
            "$($_.ParameterType) $($_.Name)"
        }) -join ", ")

    }
}

# Variante B - seit Version 5.0 möglich
[System.IO.FileStream]::new