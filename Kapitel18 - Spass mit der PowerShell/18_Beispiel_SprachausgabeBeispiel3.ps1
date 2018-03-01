<#
 .Synopsis
 Sprachausgabe mit der System.Speech-Assembly
#>

Add-Type -Assembly System.Speech -PassThru  | Where-Object { $_.IsClass -and $_.IsPublic}  | 
 Select-Object name, Namespace | Sort-Object -Property Name

$Synth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$Synth.GetInstalledVoices() | Select-Object -Expand VoiceInfo | Select-Object -Property Name, Gender, Culture
$Synth.SelectVoice("Microsoft Hedda Desktop")
$Synth.SetOutputToDefaultAudioDevice()

$LimitMB = 80
$Anzahl = (Get-Process | Where-Object WS -gt ($LimitMB * 1MB)).Count
$Ausgabe = "$Anzahl Prozesse belegen aktuell mehr als $LimitMB MB"
$Synth.Speak($Ausgabe)
