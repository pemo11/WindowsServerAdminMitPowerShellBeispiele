<#
 .Synopsis
 Farbige Ausgabe mit Write-Host
#>

function Out-Color
{
    param([Parameter(ValueFromPipeline=$true)][Object]$InputObject, 
          [Scriptblock]$ColorCondition,
          [String]$Color="Yellow")

    begin
    {
        $Ausgabe = "{0,-10}{1,-40}{2,-20}{3,-12}" -f "ID", "Name","Startzeit", "Speicher"
        Write-Host $Ausgabe
        $Ausgabe = New-Object -TypeName String -ArgumentList "-",80
        Write-Host $Ausgabe
    }
    process
    {
        foreach($Object in $InputObject)
        {
            if (&$ColorCondition)
            {
                $Ausgabe = "{0,-10}{1,-40}{2,-20}{3,-6} MB" -f $Object.ID, $Object.Name, $Object.StartTime, ([Math]::Round($Object.WS / 1MB,2))
                Write-Host $Ausgabe -F $Color
            }
            else
            {
                $Ausgabe = "{0,-10}"  -f $Object.Id
                Write-Host $Ausgabe -F Green -NoNewline
                $Ausgabe = "{0,-40}" -f $Object.Name
                Write-Host $Ausgabe -F White -NoNewline
                $Ausgabe = "{0,-20}" -f $Object.StartTime
                Write-Host $Ausgabe -F Cyan -NoNewline
                $Farbe = "White"
                if ($Object.WS -gt 100MB)
                {
                    $Farbe = "Red"
                }
                $Ausgabe = "{0,-6:n2} MB" -f ([Math]::Round($Object.WS / 1MB,2))
                Write-Host $Ausgabe -F $Farbe
            }

        }
    }

}

# Länger als 24 Stunden laufende Prozesse hervorheben
Get-Process | Out-Color  -ColorCondition { $_.StartTime -lt (Get-Date).AddHours(-24) }