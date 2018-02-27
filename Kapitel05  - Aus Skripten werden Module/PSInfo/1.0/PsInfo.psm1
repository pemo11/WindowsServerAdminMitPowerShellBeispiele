<#
 .Synopsis
 PsInfo-Moduldatei
#>

# Load the assembly file with the cmdlets definition
Import-Module -Name $PSScriptRoot\PSInfoCmdlet.dll 

<#
.Synopsis
Kombiniert die Rückgaben von Get-PCInfo und Get-TotalInfo
#>
function Get-TotalInfo
{
    $PC = Get-PCInfo
    $OS = Get-OSInfo
    [PSCustomObject]@{
        Model = $PC.Model
        Hersteller = $PC.Hersteller
        ArbeitsspeicherGB = $PC.ArbeitsspeicherGB
        CPUTyp = $PC.CPUTyp
        CPUTakt = $PC.CPUTakt
        OSName = $OS.OSName
        OSHersteller = $OS.OSHersteller
        LetztesBooten = $OS.ZeitpunktLetzesBooten
    }
}