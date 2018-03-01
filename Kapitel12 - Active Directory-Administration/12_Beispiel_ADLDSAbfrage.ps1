<#
 .Synopsis
 Abfrage eines lokalen LDAP-Dienstes basierend auf den Active Directory Lightweight Services
 .Notes
 Setzt voraus, dass der ADLDS-Dienst bereits eingerichtet wurde
#>

$ADS = [ADSISearcher]"(&(ObjectClass=person)(name=P*))"
$ADS.SearchRoot= "LDAP://localhost:389/CN=documents"
$ADS.FindAll() | ForEach-Object {
        [PSCustomObject]@{Name=$_.Properties["name"][0]
                          Beschreibung=$_.Properties["description"][0]
                        }
