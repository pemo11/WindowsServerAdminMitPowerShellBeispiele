<#
 .Synopsis
 Beispiel f�r eine Function, in der immer eine Best�tigungsanforderung ausgegeben wird
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

function Remove-XmlNodeById
{
  # CmdletBinding ist erfoderlich, damit es PSCmdlet gibt
  [CmdletBinding()]
  param([String]$Xml, [String]$NodeId)
  Add-Type -AssemblyName System.Xml.Linq
  $Root = [System.Xml.Linq.XDocument]::Parse($Xml)
  # Es kommt hier auf die Gro�-/Kleinschreibung an!
  $Node = $Root.Descendants("book") | Where-Object { $_.Attribute("id").Value -eq $NodeId }
  # Das Entfernen soll immer best�tigt werden m�ssen
 if ($PSCmdlet.ShouldContinue("Soll der Knoten mit der ID $ID gel�scht werden?", "BItte best�tigen" ))
  {
    $Node.Remove()
  }
  $Root.ToString()
}

# Das L�schen des Knotens muss immer best�tigt werden
Remove-XmlNodeById -Xml $XmlDef -NodeId 1000