<#
 .Synopsis
 Beispiel Nr. 2 f¸r eine Function mit Confirm-Parameter
#>

$XmlDef = @'
  <books>
    <book id='1000'>
      <title>Alles klar mit PowerShell</title>
    </book>
    <book id='1001'>
      <title>Viel Spaﬂ mit PowerShell</title>
    </book>
    <book id='1002'>
      <title>Noch mehr Spaﬂ mit PowerShell</title>
    </book>
  </books>
'@

function Remove-XmlNodeById
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param([String]$Xml, [String]$NodeId)
  Add-Type -AssemblyName System.Xml.Linq
  $Root = [System.Xml.Linq.XDocument]::Parse($Xml)
  # Es kommt hier auf die Groﬂ-/Kleinschreibung an!
  $Node = $Root.Descendants("book") | Where-Object { $_.Attribute("id").Value -eq $NodeId }
  # Das Entfernen soll auf Wunsch eine Best‰tigungsanforderung ausgeben
  if ($PSCmdlet.ShouldProcess($Node, "Knoten mit Id $Id entfernen?"))
  {
    $Node.Remove()
  }
  $Root.ToString()
}

# Die Function bietet einen Confirm-Parameter
Remove-XmlNodeById -Xml $XmlDef -NodeId 1000  -Confirm
