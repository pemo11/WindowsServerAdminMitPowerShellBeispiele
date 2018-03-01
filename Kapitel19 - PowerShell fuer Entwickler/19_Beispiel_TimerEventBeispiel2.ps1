<#
 .Synopsis
 Eventhandler mit Event-Variable
#> 

$Anzahl = 0
$SBTimer = {
    $Anzahl++
    if ($Anzahl -eq 3)
    {
        Unregister-Event -SourceIdentifier $Event.SourceIdentifier
    }
    
    $FColor = "Red", "Green", "Yellow", "Cyan" | Get-Random
    Write-Host -f $FColor ("*** Die aktuelle Uhrzeit: {0:HH:mm:ss} ***" -f (Get-Date))
} 

$tmr = New-Object -TypeName System.Timers.Timer
$tmr.Interval = 2000
$tmr.Start() 

Register-ObjectEvent -InputObject $tmr -EventName Elapsed `
 -SourceIdentifier TimerTest -Action $SBTimer | Out-Null 