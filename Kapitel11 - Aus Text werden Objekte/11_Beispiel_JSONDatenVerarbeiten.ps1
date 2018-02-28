<#
 .Synopsis
 Verarbeiten von JSON-Daten, die aus einer Webabfrage resultieren
 .Notes
 Setzt eine Internetverbindung voraus
#>

$SearchTerm = "Bruce Springsteen"
$Uri = "https://itunes.apple.com/search?term=$SearchTerm"
$Result = Invoke-WebRequest -Uri $Uri
$Result.Content | ConvertFrom-Json | Select-Object -ExpandProperty results | 
 Select-Object ArtistName, collectionName, trackName
