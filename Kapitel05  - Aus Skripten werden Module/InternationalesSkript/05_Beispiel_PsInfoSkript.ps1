<#
 .Synopsis
 Ein Skript mit Texten, die in eine Psd1-Datei ausgelagert werden
 .Notes
 Die Texte werden entsprechend der aktuellen Landessprache ausgewählt
#>

# Per UICulture kann eine Landessprache festgelegt werden
Import-LocalizedData -BindingVariable MsgListe  -UICulture en-US

switch ((Get-Date).Hour)
{
  { $_ -ge 5 -and $_ -le 11 } { $MsgListe.MorningGreet }
  { $_ -ge 12 -and $_ -le 17 } { $MsgListe.DayGreet }
  { $_ -ge 18 -and $_ -le 23 } { $MsgListe.EveningGreet }
  default { $MsgListe.StandardGreet }
}
