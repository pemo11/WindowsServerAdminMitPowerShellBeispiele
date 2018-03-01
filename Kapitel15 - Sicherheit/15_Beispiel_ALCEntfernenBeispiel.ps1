<#
 .Synopsis
 Entfernen aller vorhanden Verzeichnisberechtigungen und Hinzufügen einer neuen Berechtigung
#>
function Clear-ACL
{
  [CmdletBinding()]
  param([String]$Pfad)
  $ACL = Get-Acl -Path $Pfad

  # Vererbung und Schutz außer Kraft setzen
  $ACL.SetAccessRuleProtection($true, $true)
  Set-ACL -Path $Pfad -AclObject $ACL

  # Wichtig: Get-ACL muss nach dem Aktualisieren erneut ausgeführt werden
  $ACL = Get-Acl -Path $Pfad

  # Alle Regeln durchgehen
  foreach($Rule in $ACL.Access)
  {
    Write-Verbose ("Identität: {0} Berechtigung: {1}" -f $Rule.IdentityReference, $Rule.FileSystemRights)
    # Alle Zugriffsberechtigungen mit der SID der Zugriffsregel $Rule entfernen
    $ACL.RemoveAccessRule($Rule) | Out-Null
  }

  # ACL aktualisieren
  Set-ACL -Path $Pfad -AclObject $ACL
  # Eine neue Regel hinzufügen
  $Rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList "Administrator", "FullControl", "None", "None", "Allow"
  $ACL.AddAccessRule($Rule)

  # ACL aktualisieren
  Set-ACL -Path $Pfad -AclObject $ACL
}

