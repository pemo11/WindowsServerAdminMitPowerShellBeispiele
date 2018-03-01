<#
 .Synopsis
 Abspielen einer Tonfolge - Beispiel Nr. 3
 .Notes - wieder das HELLO in Solresol - dieses Mal mit "echten" Noten
#>
function Play-Melodie
{
    param([Object[]]$Melodie)
    foreach($Tone in $Melodie)
    {
        if ($Tone[0] -eq "Pause")
        {
            Start-Sleep -Milliseconds $Tone[1]
        }
        else
        {
            [System.Console]::Beep($Tone[0], $Tone[1])
        }
    }
}

$Tones = @{GBelowC=196;A=200;ASharp=233;B=247;C=262;CCharp=277;D=294;DSharp=311;E=330;F=349;FSharp=370;G=392;GSharp=415}
$Duration = @{WHOLE=1600;HALF=800;QUARTER=400;EIGHTH=200;SIXTEENTH=100}

# Unh. Begeg. d. 3ten A. - soll nach Solresol für ein HELLO stehen g' – a' – f' – f – c'
$Melodie  = ($Tones.G, $Duration.QUARTER), ("Pause", 400), ($Tones.B, $Duration.HALF), ($Tones.F, $Duration.QUARTER), ($Tones.F, $Duration.QUARTER), ($Tones.C, $Duration.QUARTER)

Play-Melodie -Melodie $Melodie


