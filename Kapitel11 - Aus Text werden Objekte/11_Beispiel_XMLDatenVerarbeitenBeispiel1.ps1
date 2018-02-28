<#
 .Synopsis
XML-Daten verarbeiten mit dem [Xml]-Typenalias
#>

$XmlDaten = @'
<root>
 <el a='1'>100</el>
 <el a='2'>200</el>
 <el a='3'>300</el>
</root>
'@

$Daten = ([Xml]$XmlDaten)


$Daten.root.el."#text"

$Daten.root.el.ForEach{ $_."#text" = [String]([int]$_."#text" * 2)}

$Daten.root.el."#text"

$Daten.Save((Join-Path (gl) "XmlDatenNeu.xml"))