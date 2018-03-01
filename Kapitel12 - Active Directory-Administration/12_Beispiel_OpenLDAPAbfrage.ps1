<#
 .Synopsis
 Abfrage eines öffentlichen Open LDAP-Service
 .Notes
 Setzt eine Internet-Verbindung voraus
#>


$Server = "LDAP://ldap.forumsys.com:389/DC=example,DC=com"
$DN = "cn=read-only-admin,dc=example,dc=com"

$Filter = "(objectClass=*)"
$Pw = "password"

$DirEntry = New-Object -TypeName System.DirectoryServices.DirectoryEntry `
 -ArgumentList $Server, $DN, $Pw, "FastBind"
$DirSearcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher `
 -ArgumentList $DirEntry, $Filter

$DirSearcher.FindAll() | Select-Object -ExpandProperty Properties | ForEach-Object {
    New-Object -TypeName PsObject -Property @{
                                              CN = $_["cn"]
                                              Class=$_["Objectclass"]
                                              Path = $_["adspath"]
                                             }
}