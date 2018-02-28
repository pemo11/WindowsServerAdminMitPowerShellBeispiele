<#
 .Synopsis
XML-Daten verarbeiten mit dem Select-Xml-Cmdlet
#>

$XmlDaten = @'
<root>
 <el a='1'>100</el>
 <el a='2'>200</el>
 <el a='3'>300</el>
</root>
'@

Select-Xml -Content $XmlDaten -XPath "//el" |
 ForEach-Object { 
     [PSCustomObject]@{Attrib=$_.Node.Attributes["a"].Value; Wert=$_.Node.InnerText}
}