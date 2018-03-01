<#
 .Synopsis
 Abspielen einer Tonfolge - Beispiel Nr. 1
#>

# Unh. Begeg. d. 3ten A. - soll nach Solresol für ein HELLO stehen g' – a' – f' – f – c'
$Toene = (800,400), (1000,400), (900,400), (400,800), (600,1600)

foreach($t in $Toene)
{
  [System.Console]::Beep($t[0], $t[1])
}