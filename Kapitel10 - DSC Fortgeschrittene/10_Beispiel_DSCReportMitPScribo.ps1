<#
 .Synopsis
 DSC-Report mit PScribo
 .Notes
 Setzt das Modul PScribo voraus
#>

Set-StrictMode -Version Latest

# Find-Module -Name PScribo
# Install-Module -Name PScribo -Force
# Get-Module -Name PScribo -ListAvailable

<#
.Synopsis
Abfrage eines Reportservice für einen Agent
#>
function Get-DSCData
{
    [CmdletBinding()]
    param([String]$AgentId,
          [String]$Url)
    $RequestUri = "$Url/Nodes(AgentId='$AgentId')/Reports"
    $Request = Invoke-WebRequest -Uri $RequestUri  `
               -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing `
               -Headers @{Accept = "application/json";ProtocolVersion = "2.0"}
    $Content = $Request.Content | ConvertFrom-Json
    return $Content.value
}

<#
  .Synopsis
  Hilfsfunktion für die Datumsformat-Konvertierung
#>
function ConvertFrom-DSCTime
{
    param([String]$DSCTime)
    $DSCPattern = "(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})"
    if ($DSCTime -Match $DSCPattern)
    {
        Get-Date -Year $Matches[1] -Month $Matches[2] -Day $Matches[3] -Hour $Matches[4] -Minute $Matches[5]
    }
    else
    {
        Get-Date -Year 2000 -Month 1 -Day 1
    }
}

<#
 .Synopsis
 Liefert die AgentIDs der einzelnen DSC-Nodes
#>
function Get-NodeLCM
{
    # Hashtable für Computername/Credentials anlegen
    $PwSec1 = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
    $PSCred1 = [PSCredential]::new("Administrator", $PwSec1)
    $PSCred2 = [PSCredential]::new("pemo", $PwSec1)

    $CredHash = @{}
    $CredHash += @{"Win10A"=$PSCred2}
    $CredHash += @{"Win10B"=$PSCred2}
    $CredHash += @{"W2016X"=$PSCred1}

    $CIMHash = @{}
    # Für jeden Computer eine CIM-Session anlegen
    foreach($Computer in $CredHash.Keys)
    {
        try
        {
            $CIMHash += @{$Computer = (New-CIMSession -Computername $Computer -Credential $CredHash[$Computer] -ErrorAction Stop)}
        }
        catch 
        {
            Write-Warning "Für $Computer kann keine CIM-Session angelegt werden."
        }
    }

    # Hashtable mit allen AgentIds anlegen
    $AgentHash = @{}
    # AgentIds abfragen
    foreach($Computer in $CIMHash.Keys)
    {
        try
        {
            $AgentId = (Get-DscLocalConfigurationManager -CimSession $CIMHash[$Computer]).AgentId
            $AgentHash += @{$AgentId=$Computer}
        }
        catch 
        {
            Write-Warning "Für $Computer kann kein LCM-Status abgefragt werden."
        }
    }
    # Alle CIM-Sessions entfernen
    $CIMHash.Values | Remove-CIMSession
    # Rückgabewert 
    $AgentHash
}

<#
 .Synopsis
 Liefert die Konfigurationsänderungen für einen Node
#>
function Get-DSCReport
{
    param([String]$AgentID,[String]$Computer)
    $ReportObjects = @()
    $ObjectsInDesiredState = @()
    $ObjectsNotInDesiredState = @()
    $PullserverUrl = "http://w2016A:8082/PSDSCPullServer.svc"
    # Report-Services für jeden Node abfragen
    $Report = Get-DSCData -AgentId $AgentId -Url $PullServerUrl
    $ReportObject = $Report | Select-Object -ExpandProperty StatusData | ConvertFrom-JSON |
         Where-Object NumberOfResources -gt 0 -ErrorAction Ignore
    
    # Gibt es die Eigenschaft RessourcesInDesiredState?
    if ($ReportObject | Get-Member -Name ResourcesInDesiredState)
    {
        $ObjectsInDesiredState += ($ReportObject | Where-Object ResourcesInDesiredState -ne $null | 
                                Select-Object -ExpandProperty ResourcesInDesiredState |
                                Select-Object @{n="Computer";e={$Computer}},
                                              @{n="Startzeit";e={(ConvertFrom-DSCTime $_.StartDate)}},
                                              @{n="Instanz";e={$_.InstanceName}},
                                              @{n="Konfiguration";e={$_.ConfigurationName}},
                                              @{n="InDesiredState";e={$_.InDesiredState}}
                                )
        $ReportObjects += $ObjectsInDesiredState
    }


    # Gibt es die Eigenschaft ResourcesNotInDesiredState?
    if ($ReportObject | Get-Member -Name ResourcesNotInDesiredState)
    {
        $ObjectsNotInDesiredState += ($ReportObject | Where-Object ResourcesNotInDesiredState -ne $null -ErrorAction Ignore | 
                                Select-Object -ExpandProperty ResourcesNotInDesiredState |
                                Select-Object @{n="Computer";e={$Computer}},
                                              @{n="Startzeit";e={(ConvertFrom-DSCTime $_.StartDate)}},
                                              @{n="Instanz";e={$_.InstanceName}},
                                              @{n="Konfiguration";e={$_.ConfigurationName}},
                                              @{n="InDesiredState";e={$_.InDesiredState}}
                                )
        $ReportObjects += $ObjectsNotInDesiredState
    }
    return $ReportObjects
}

# $AgentList = Get-NodeLCM
# Get-DSCReport -AgentID $AgentList.Keys[0]

document -Id DSCReport  {

    DocumentOption -EnableSectionNumbering

    Paragraph -Style Heading1 ("DSC-Report vom {0:d} - {0:t}" -f (Get-Date))

    $AgentHash = Get-NodeLCM

    TOC -Name "Zusammenfassung"

    PageBreak

    $AgentList = Get-NodeLCM

    foreach($AgentId in $Agentlist.Keys)
    {
        $Computer = $Agentlist[$AgentId]

        Section -Style Heading2 -Name "Zuletzt durchgeführte Konfigurationsänderungen auf $Computer"  {
         Paragraph -Style Heading3  "Reportservice-Abfrage für $Computer"

         $ReportObjects = Get-DSCReport -AgentID $AgentId  -Computer $Computer
         $IndesiredStateObjects = $ReportObjects | Where IndesiredState -eq $true
         $NotIndesiredStateObjects = $ReportObjects | Where IndesiredState -eq $false

         BlankLine -Count 2

         Paragraph -Style Heading3  "$(@($IndesiredStateObjects).Count) Konfigurationen sind im gewünschten Zustand"
         Linebreak

         if ($IndesiredStateObjects -ne $null) 
         {
             $IndesiredStateObjects | Table
         }

         BlankLine -Count 2

         Paragraph -Style Heading3  "$(@($NotIndesiredStateObjects).Count) Konfigurationen sind nicht im gewünschten Zustand"
         Linebreak

         if ($NotIndesiredStateObjects -ne $null) 
         {
            $NotIndesiredStateObjects | Table
         }
    
        }
        PageBreak
    }

} | Export-Document -Path . -Format Html,word -Verbose

.\DSCReport.docx

