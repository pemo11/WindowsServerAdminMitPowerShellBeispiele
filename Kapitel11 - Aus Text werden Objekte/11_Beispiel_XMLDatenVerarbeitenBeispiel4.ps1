<#
 .Synopsis
XML-Daten verarbeiten und verändern
#>

$XmlDaten = @'
 <inventar>
   <geraet id="1000" preis="100">
     <kategorie>Drucker</kategorie>
     <bezeichnung>HP Laserjet II</bezeichnung>
   </geraet>
   <geraet id="1001" preis="120">
     <kategorie>Drucker</kategorie>
     <bezeichnung>Epson Fx80</bezeichnung>
   </geraet>
   <geraet id="1002" preis="40.50">
     <kategorie>Festplatte</kategorie>
     <bezeichnung>Seagate 200MByte</bezeichnung>
   </geraet>
 </inventar>
'@

(([Xml]$XmlDaten).inventar.geraet | Measure-Object -Property Preis -Sum).Sum
