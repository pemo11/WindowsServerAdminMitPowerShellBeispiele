<#
 .Synopsis
XML-Daten mit einem Präfix verarbeiten mit dem Select-Xml-Cmdlet
#>

$XmlDaten = @'
<root xmlns:test="urn:xyz">
 <test:el a='1'>100</test:el>
 <test:el a='2'>200</test:el>
 <test:el a='3'>300</test:el>
</root>
'@
$Ns = @{test="urn:xyz"}

Select-Xml -Content $XmlDaten -XPath "//el" |
 ForEach-Object { 
     [PSCustomObject]@{Attrib=$_.Node.Attributes["a"].Value; Wert=$_.Node.InnerText}
}

Select-Xml -Namespace $Ns -Content $XmlDaten -XPath "//test:el" | 
 ForEach-Object { 
     [PSCustomObject]@{Attrib=$_.Node.Attributes["a"].Value; Wert=$_.Node.InnerText}
}