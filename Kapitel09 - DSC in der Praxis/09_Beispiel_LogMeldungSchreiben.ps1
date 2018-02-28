<#
 .Synopsis
 Log-Meldung schreiben
 .Nodes
 Das Eventlog  Microsoft-Windows-DSC/Analytic muss einmalig per 
 Wevtutil sl Microsoft-Windows-DSC/Analytic /e:true
 aktiviert werden
#>

configuration DSCLogBeispiel
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  node localhost
  {
        Log Log1
        {
            # Erscheint im Microsoft-Windows-DSC/Analytic-Log als Teil von Message
            Message = ("Alles klar mit DSC am {0:dddd}" -f (Get-Date))
        }
  }
}

DSCLogBeispiel

Start-DscConfiguration -Path .\DSCLogBeispiel -Wait -Verbose -Force

# Abfrage des Eventlogs und Ausfiltern der unwichtigen Einträge
Get-WinEvent -LogName Microsoft-Windows-DSC/Analytic -Oldest | Where-Object {
    $_.Message -match "Meldung:" -and $_.Message -notmatch "LCM" } | 
    Select-Object -ExpandProperty Message
