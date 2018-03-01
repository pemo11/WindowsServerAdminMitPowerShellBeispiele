<#
 .Synopsis
 Aktivieren des AD-Papierkorbs
 .Notes
 Geht ab Windows Server 2012 R2 auch im ActiveDirectory-Verwaltungscenter
 #>

$DomName = "pskurs.local"
$DomDN = "DC=pskurs,DC=local"

Enable-ADOptionalFeature  `
  -Identity "CN=Recycle Bin Feature, CN=Optional Features, CN=Directory 
  Service, CN=Windows NT, CN=Services, CN=Configuration, $DomDN" `
  –Scope ForestOrConfigurationSet –Target $DomName
