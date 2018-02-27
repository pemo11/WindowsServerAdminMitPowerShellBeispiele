<#
 .Synopsis
 Anlegen von lokalen Benutzer- und Gruppenkonten per DSC
 .Notes
 Im Buch ist Ensure jeweils auf "Absent" gesetzt - das ist insofern falsch, als
 das dadurch die Konten wieder entfernt werden
#>

configuration UserGroupAnlegen
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration

  Node $AllNodes.Nodename
  {
     User User1
     {
        Ensure = "Present"
        UserName = $Node.Username1
        FullName = $Node.UserFullName1
        PasswordNeverExpires = $true
        Password = $Node.Credential
     }

     User User2
     {
        Ensure = "Present"
        UserName = $Node.Username2
        FullName = $Node.UserFullName2
        PasswordNeverExpires = $true
        Password = $Node.Credential
     }

     Group Group1
     {
        Ensure="Present"
        GroupName=$Node.GroupName
        Members = $Node.Username1, $Node.Username2
        DependsOn = "[User]User2"
     }
  }
}

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Username = "SpieltKeineRolle"
$PSCred = [PSCredential]::new($username, $PwSec)

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "localhost"
            Username1 = "PsUser1"
            Username2 = "PsUser2"
            UserFullName1 = "Posh User 1"
            UserFullName2 = "Posh User 2"
            GroupName = "PoshUser"
            Credential = $PSCred
            PSDscAllowPlainTextPassword = $true
        }
    )
}

UserGroupAnlegen -ConfigurationData $ConfigData

# Start-DscConfiguration -Path .\UserGroupAnlegen -Wait -Verbose -Force