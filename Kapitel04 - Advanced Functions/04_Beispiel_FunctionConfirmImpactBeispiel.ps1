<#
 .Synopsis
 Beispiel für die Rolle von ConfirmImpact
#>

$XmlDef = @'
  <books>
    <book id='1000'>
      <title>Alles klar mit PowerShell</title>
    </book>
    <book id='1001'>
      <title>Viel Spa� mit PowerShell</title>
    </book>
    <book id='1002'>
      <title>Noch mehr Spa� mit PowerShell</title>
    </book>
  </books>
'@

<#
.Synopsis
Entfernt einen Knoten in einer Xml-Struktur
#>
function Remove-XmlNodeById
{
  # Der Standardwert von ConfirmImpact ist Medium
  [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="Medium")]
  param([String]$Xml, [String]$NodeId)
  Add-Type -AssemblyName System.Xml.Linq
  $Root = [System.Xml.Linq.XDocument]::Parse($Xml)
  # Es kommt hier auf die Gro�-/Kleinschreibung an!
  $Node = $Root.Descendants("book") | Where-Object { $_.Attribute("id").Value -eq $NodeId }
  # Das Entfernen soll auf Wunsch eine Best�tigungsanforderung ausgeben
  if ($PSCmdlet.ShouldProcess($Node, "Knoten mit Id $Id entfernen?"))
  {
    $Node.Remove()
  }
  $Root.ToString()
}

# Ohne Confirm-Parameter erscheint bei ConfirmPreference=High keine Best�tigungsanforderung
$ConfirmPreference = "High"
Remove-XmlNodeById -Xml $XmlDef -NodeId 1000 

# Durch Setzen von ConfirmImpact auf Low oder Medium erscheint auch ohne Confirm eine Best�tigungsanforderung
$ConfirmPreference = "Medium"
Remove-XmlNodeById -Xml $XmlDef -NodeId 1001

$ConfirmPreference = "Low"
Remove-XmlNodeById -Xml $XmlDef -NodeId 1002

$ConfirmPreference = "High"
