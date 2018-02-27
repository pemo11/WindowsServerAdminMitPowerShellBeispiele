<#
 .Synopsis
 Enthält weitere Functions, die z.B. von der Psm1-Datei verwendet werden
#>

function Get-WochentagLetztesBooten
{
    $OS = Get-OSInfo
    # Eine explizite Konvertierung des WMI-Datums ist nicht erforderlich,
    # da dies bereits die Typendefinitionsdatei PSInfoTypes.ps1xml übernimmt (cool)
    # $Datum = ([WMI]"").ConvertToDateTime($OS.LetzterBootZeitpunkt)
    $OS.LetzterBootZeitpunkt.ToString("dddd")
}