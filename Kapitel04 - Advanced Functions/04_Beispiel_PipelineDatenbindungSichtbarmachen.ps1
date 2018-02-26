<#
 .Synopsis
 Sichtbar machen der Parameter-Pipeline-Bindung
#>

Start-Process -FilePath mspaint
$SB = { "mspaint" | Stop-Process }
Trace-Command –Name ParameterBinding -PSHost –Expression $SB -FilePath $env:temp\PSTraceLog.txt

# Notepad $env:temp\PSTraceLog.txt