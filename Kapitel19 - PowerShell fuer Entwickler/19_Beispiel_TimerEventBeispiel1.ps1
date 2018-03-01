<#
 .Synopsis
 Der "richtige" Umgang mit einem Timer-Event
 .Description
 Das Timer-Event Elpased gibt alle 5s die Uhrzeit aus
#>
 
$SBTimer = {
    $FColor = "Red", "Green", "Yellow", "Cyan" | Get-Random
    Write-Host -f $FColor ("*** Die aktuelle Uhrzeit: {0:HH:mm:ss} ***" -f (Get-Date))
} 

$tmr = New-Object -TypeName System.Timers.Timer
$tmr.Interval = 5000
$tmr.Start()

Register-ObjectEvent -InputObject $tmr `
 -EventName Elapsed -SourceIdentifier "TimerTest" `
 -Action $SBTimer

# Abschalten des Time-Events
# Unregister-Event -SourceIdentifier "TimerTest"
 