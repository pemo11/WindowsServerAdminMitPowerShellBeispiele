<#
 .Synopsis
 Konvertieren von unregelmäßig aufgebautem Text per ConvertFrom-String
#>

$Textdaten = @"
Daten
=================
Wert1: 1000
Wert2: 2000
Wert3: 3000

=================
Wert1: 1001
Wert2: 2001
Wert3: 3001
=================
Wert1: 1002
Wert2: 2002
Wert3: 3002
=================
Wert1: 1003
Wert2: 2003
Wert3: 3003
"@

$Vorlage = @'
  Daten
  =================
  Wert1: {W1*:1234}
  Wert2: {W2:1234}
  Wert3: {W3:1234}
‚  =================
  Wert1: {W1*:1234}
  Wert2: {W2:1234}
'@

$Textdaten | ConvertFrom-String -TemplateContent $Vorlage