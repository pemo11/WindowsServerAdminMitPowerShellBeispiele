<#
 .Synopsis
 Quote of the Day Service (QOTD) abfragen
 .Notes
 Der Dienst Simptcp muss ausführen - dieser wird über das Feature "Einfache TCPIP-Dienste" hinzugefügt
#>

$QOTDHost = "localhost"
$UDPClient = New-Object -TypeName System.Net.Sockets.Udpclient

$UDPClient.Connect($QOTDHost, 17)
$UDPClient.Client.ReceiveTimeout = 1000

# Beliebige Textmeldung an den QOTD-Service schicken
$ACSCII = New-Object -TypeName System.Text.ASCIIEncoding
$ByteBuf = $ACSCII.GetBytes("Test1234")
[void]$UDPClient.Send($ByteBuf, $ByteBuf.Length)

# Verbindung mit dem Endpunkt (localhost - Port 17) herstellen
$RemoteEnd = New-Object -TypeName System.Net.IPEndPoint -ArgumentList ([System.Net.IPAddress]::Any), 0
try
{
    # Byte-Daten abrufen
    $BytesReceived = $UDPClient.Receive([ref]$RemoteEnd)
    # Aus Byte-Folge Text machen
    $Quote = $ACSCII.GetString($BytesReceived)
    # Zitat ausgeben
    $Quote
}
catch
{
    Write-Warning "Fehler beim Abrufen von Daten ($_)"
}

# Verbindung wieder schließen
$UDPClient.Close()