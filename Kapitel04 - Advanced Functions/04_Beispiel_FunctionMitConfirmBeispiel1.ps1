<#
 .Synopsis
 Beispiel Nr. 1f¸r eine Function mit Confirm-Parameter
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

<#
.Synopsis
Entfernt einen Knoten in einer Xml-Struktur
#>
function Remove-XmlNodeById
{
  param([String]$Xml, [String]$NodeId)
  Add-Type -AssemblyName System.Xml.Linq
  $Root = [System.Xml.Linq.XDocument]::Parse($Xml)
  # Es kommt hier auf die Groﬂ-/Kleinschreibung an!
  $Node = $Root.Descendants("book") | Where-Object { $_.Attribute("id").Value -eq $NodeId }
  $Node.Remove()
  $Root.ToString()
}

# Der Knoten wird immer entfernt
Remove-XmlNodeById -Xml $XmlDef -NodeId 1000
