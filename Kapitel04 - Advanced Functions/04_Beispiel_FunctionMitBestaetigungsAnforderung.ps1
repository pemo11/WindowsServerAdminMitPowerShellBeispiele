<#
 .Synopsis
 Beispiel für eine Function, in der immer eine Bestätigungsanforderung ausgegeben wird
#>

$XmlDef = @'
  <books>
    <book id='1000'>
      <title>Alles klar mit PowerShell</title>
    </book>
    <book id='1001'>
      <title>Viel Spaß mit PowerShell</title>
    </book>
    <book id='1002'>
      <title>Noch mehr Spaß mit PowerShell</title>
    </book>
  </books>
'@

function Remove-XmlNodeById
{
  # CmdletBinding ist erfoderlich, damit es PSCmdlet gibt
  [CmdletBinding()]
  param([String]$Xml, [String]$NodeId)
  Add-Type -AssemblyName System.Xml.Linq
  $Root = [System.Xml.Linq.XDocument]::Parse($Xml)
  # Es kommt hier auf die Groß-/Kleinschreibung an!
  $Node = $Root.Descendants("book") | Where-Object { $_.Attribute("id").Value -eq $NodeId }
  # Das Entfernen soll immer bestätigt werden müssen
 if ($PSCmdlet.ShouldContinue("Soll der Knoten mit der ID $ID gelöscht werden?", "BItte bestätigen" ))
  {
    $Node.Remove()
  }
  $Root.ToString()
}

# Das Löschen des Knotens muss immer bestätigt werden
Remove-XmlNodeById -Xml $XmlDef -NodeId 1000