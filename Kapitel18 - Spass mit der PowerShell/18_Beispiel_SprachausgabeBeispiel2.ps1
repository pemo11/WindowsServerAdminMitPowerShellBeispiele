<#
 .Synopsis
 Sprachausgabe per SAPI
#>

$SPVoice.GetVoices() | ForEach-Object { $_.GetDescription() }

# The English Voice holen
$USVoice = $SPVoice.GetVoices() | Where-Object { $_.GetDescription() -match "English" }
$USVoiceName = $USVoice.GetDescription()
$USVoiceName = $USVoiceName.Substring(0, $USVoiceName.IndexOf("-") -1)
$USVoice  = $SpVoice.GetVoices("Name=" + $USVoiceName).Item(0)
$SPVoice.Voice = $USVoice
$SprachText = "The NSA knows you very good"
$SPVoice.Speak($SprachText)


