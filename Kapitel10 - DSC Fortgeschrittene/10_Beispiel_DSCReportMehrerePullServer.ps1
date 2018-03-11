<#
 .Synopsis
 Abfrage mehrerer PullServer
#>

Set-StrictMode -Version Latest

<#
.Synopsis
Abfrage eines Reportservice für einen Agent
#>
function Get-DSCReport
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

# Hashtable fuer Computername/Credentials anlegen
$PwSec1 = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred1 = [PSCredential]::new("Administrator", $PwSec1)
$PSCred2 = [PSCredential]::new("pemo", $PwSec1)

$CredHash = @{}
$CredHash += @{"Win10A"=$PSCred2}
$CredHash += @{"W2016X"=$PSCred1}

Write-Verbose ("Hashtable CredHash mit {0} Eintraegen angelegt." -f $CredHash.Count) -Verbose

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

Write-Verbose ("Hashtable CIMHash mit {0} Einträgen angelegt." -f $CIMHash.Count) -Verbose


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

Write-Verbose ("Hashtable AgentHash mit {0} Einträgen angelegt." -f $AgentHash.Count) -Verbose

# Alle CIM-Sessions entfernen
$CIMHash.Values | Remove-CIMSession

Write-Verbose ("{0} CIM-Sessions entfernt." -f $CIMHash.Count) -Verbose

# Es gibt einen Pullserver
$PullServerUrl = "http://w2016A:8082/PSDSCPullServer.svc"

# 2018-03-08T21:11:48.1850000+01:00
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

$ReportObjects = @()
# Report-Services für jeden Node abfragen
foreach($AgentId in $AgentHash.Keys)
{
    $Report = Get-DSCReport -AgentId $AgentId -Url $PullServerUrl
    $ReportObject = $Report | Select-Object -ExpandProperty StatusData | ConvertFrom-JSON | Where NumberOfResources -gt 0 -ErrorAction Ignore

    $ReportObjects += ($ReportObject | Select -ExpandProperty ResourcesInDesiredState |
                        Select @{n="Computer";e={$AgentHash[$AgentId]}},
                               @{n="Startzeit";e={(ConvertFrom-DSCTime $_.StartDate)}},
                               @{n="Instanz";e={$_.InstanceName}},
                               @{n="Konfiguration";e={$_.ConfigurationName}},
                               @{n="InDesiredState";e={$_.InDesiredState}}
                     )
}

$ReportObjects | Format-table -AutoSize