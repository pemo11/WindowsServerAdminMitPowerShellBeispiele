<#
 .Synopsis
 Farbiger Prompt mit Pfad-Verkürzung
#>

function Get-ShortPath
{
    param([String]$Path)
    # Heimverzeichnis durch ~ ersetzen - Replace-Methode statt replace-Operator, damit Zeichen wie \ nicht escaped werden müssen
    $ShortPath = $Path.Replace($HOME, "~") 
    # PSProvider-Name entfernen
    $ShortPath = $ShortPath -replace "^[^:]+::", "" 
    # Der Regex bricht bei jedem Verzeichnisnamen bis auf den Letzten mit dem ersten Zeichen ab, das kein \ ist
    # Ausnahmen sind \\ und \\.
    $ShortPath -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2'
}

function Prompt
{ 
   $ColorDelim = [ConsoleColor]::DarkCyan 
   $ColorHost = [ConsoleColor]::Green 
   $ColorPath = [ConsoleColor]::Cyan 
   # Alternative: 0x0A7
   Write-Host "$([Char]0x024) " -N -F $ColorDelim
   Write-Host "$(HostName)@($env:UserName)" -N -F $ColorHost
   Write-Host ' {' -n -f $ColorDelim 
   Write-Host (Get-ShortPath (Pwd).Path) -n -f $ColorPath
   Write-Host '}' -n -f $ColorDelim 
}

