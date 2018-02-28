

$ADS = [ADSISearcher]"(&(ObjectClass=person)(name=P*))"
$ADS.SearchRoot= "LDAP://localhost:389/CN=documents"
$ADS.FindAll() | ForEach {
    [PSCustomObject]@{Name=$_.Properties["name"][0]
                      Beschreibung=$_.Properties["description"][0]
                    }
