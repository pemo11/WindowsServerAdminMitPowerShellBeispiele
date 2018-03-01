<#
 .Synopsis
 Sprachausgabe per SAPI
#>

$SprachText = "Gehen Sie direkt ins Gefängnis, gehen Sie nicht über Los."
$SPVoice = New-Object -ComObject SAPI.SpVoice

# Mit der Standardsprache ausgeben
$SPVoice.Speak($SprachText)

