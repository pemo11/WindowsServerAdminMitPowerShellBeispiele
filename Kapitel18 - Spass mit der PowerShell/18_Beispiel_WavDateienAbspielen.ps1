<#
 .Synopsis
 Wave-Dateien abspielen
#>

$WavDateien = Get-ChildItem -Path C:\Windows\Media\*.wav
$Anzahl = 0
foreach($Wav in $WavDateien )
{
  $Anzahl++
  Write-Progress -Activity "Windows-Wav-Dateien" -Status "Spiele $($Wav.Name)" `
   -PercentComplete (($Anzahl / $WavDateien.Count) * 100)
   $Player = New-Object -TypeName System.Media.SoundPlayer -ArgumentList $Wav.FullName
   $Player.PlaySync()
}
