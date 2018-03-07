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

Get-DSCReport -AgentId $AgentId -Url $PullServerUrl | Select-Object -ExpandProperty StatusData | 
 ConvertFrom-JSON