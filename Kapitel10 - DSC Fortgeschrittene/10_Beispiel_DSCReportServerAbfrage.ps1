<#
 .Synopsis
 Abfrage eines DSC-Reportservice
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

# Diese Angaben bitte anpassen
$PullServerUrl = "http://w2016A:8082/PSDSCPullServer.svc"
$AgentId = "9C868702-0D03-11E8-BEB7-000C29EE8A81"
$AgentId = "a652e94b-0e5d-11e8-9660-000c292026c5"
# 239 Objekte vom Typ PSCustomObject
# Members: Hostname, IPv4Addresses, JobID, NumberOfResources, StartDate, ResourcesInDesiredState
# Status
Get-DSCReport -AgentId $AgentId -Url $PullServerUrl | Select-Object -ExpandProperty StatusData | 
 ConvertFrom-JSON | Select StartDate, HostName, IPv4Addresses, NumberOfResources, ResourcesInDesiredState

 Get-DSCReport -AgentId $AgentId -Url $PullServerUrl | Select-Object -ExpandProperty StatusData | 
  ConvertFrom-JSON | Where NumberOfResources -gt 0 | Select -ExpandProperty ResourcesInDesiredState