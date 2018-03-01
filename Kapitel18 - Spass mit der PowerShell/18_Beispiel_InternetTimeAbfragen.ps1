<#
 .Synopsis
 Internet-Time Server direkt abfragen
#>

$TimeServer = "128.138.140.44",
              "64.90.182.55",
              "206.246.118.250",
              "207.200.81.113",
              "128.138.188.172",
              "64.113.32.5",
              "64.147.116.229",
              "64.125.78.85",
              "128.138.188.172"

$OldVerbosePref = $VerbosePreference
$VerbosePreference = "Continue"

$Port = 13

foreach($Server in $TimeServer)
{
    Write-Verbose "Checking $Server..."
    try
    {
        $Sockets = New-Object -TypeName System.Net.Sockets.TcpClient -ArgumentList $Server, $Port
        $SocketStream = $Sockets.GetStream()
        $Reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $SocketStream
        $Reader.ReadLine()
        $ServerResponse = $Reader.ReadLine()
        Write-Verbose "Server-Reponse: $ServerResponse"
        [void]($ServerResponse -match "\d+\s+(?<Year>\d{2})-(?<Day>\d{2})-(?<Month>\d{2})\s+(?<Hour>\d{2}):(?<Minute>\d{2}):(?<Second>\d{2})")
        $Year = "20$($Matches.Year)"
        $Month = $Matches.Month
        $Day = $Matches.Day
        $Hour = $Matches.Hour 
        $Minute = $Matches.Minute
        $Second = $Matches.Second 
        $InternetTime = Get-Date -Year $Year -Month $Month -Day $Day -Hour $Hour -Minute $Minute -Second $Second
        "The current Internet time from Server $Server`: $InternetTime"
        break
    }
    catch
    {
        "No connection with $Server possible - lets try the next one."
    }
}

$VerbosePreference = $OldVerbosePref