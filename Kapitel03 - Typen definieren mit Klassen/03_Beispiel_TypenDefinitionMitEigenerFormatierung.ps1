<#
 .Synopsis
 Individuelle Typenformatierung für Objekte des Typs UserData
#>

# Definition einer Tabellenformatierung für den Typ UserData
$UserDataFormatDef = @'
<Configuration>
  <ViewDefinitions>
    <View>
      <Name>Standard</Name>
      <ViewSelectedBy>
         <TypeName>UserData</TypeName>
       </ViewSelectedBy>
       <TableControl>
          <TableHeaders>
            <TableColumnHeader>
              <Label>User-Id</Label>
              <Width>10</Width>
            </TableColumnHeader>
            <TableColumnHeader>
              <Label>Name</Label>
              <Width>16</Width>
            </TableColumnHeader>
            <TableColumnHeader>
              <Label>User-Typ</Label>
              <Width>12</Width>
            </TableColumnHeader>
            <TableColumnHeader>
              <Label>Domäne</Label>
              <Width>24</Width>
            </TableColumnHeader>
           </TableHeaders>
           <TableRowEntries>
             <TableRowEntry>
               <TableColumnItems>
                 <TableColumnItem>
                     <ScriptBlock>$_.Id</ScriptBlock>
                 </TableColumnItem>
                 <TableColumnItem>
                     <ScriptBlock>$_.UserName</ScriptBlock>
                 </TableColumnItem>
                 <TableColumnItem>
                     <ScriptBlock>switch ($_.UserType) { "Domain" { "Domäne"} default {"Keine" }}</ScriptBlock>
                 </TableColumnItem>
                 <TableColumnItem>
                     <ScriptBlock>$_.DomainName</ScriptBlock>
                 </TableColumnItem>
               </TableColumnItems>
             </TableRowEntry>
           </TableRowEntries>
       </TableControl>
    </View>        
  </ViewDefinitions>
</Configuration>
'@

# Speichern des Xml in eine Textdatei
$FormatPath = Join-Path -Path $PSScriptRoot -ChildPath "UserData.format.ps1xml"
$UserDataFormatDef | Set-Content -Path $FormatPath

# Aktualisieren der Typenformatierung der PowerShell
Update-FormatData -PrependPath $FormatPath

# Definition eines Enum
enum UserType
{
    Domain
    Local
}

# Definition der Klasse UserData
class UserData
{
    [String]$UserName
    [UserType]$UserType
    [Int]$Id

    UserData()
    {
        $this.Id = -1
        $this.UserType = "Local"
    }
}

# Definition der Klasse DomainUserData
class DomainUserData : UserData
{
    [String]$DomainName

    DomainUserData([Int]$Id)
    {
        $this.Id = $Id
        $this.UserType = "Domain"
    }
}

# Anlegen eines DomainUserData-Objekts
$User1 = [DomainUserData]::new(100)
$User1.UserName = "Erwin L."
$User1.DomainName = "pskurs.local"
$User1

# Anlegen eines UserData-Objekts
# Anlegen eines Objekts vom Typ UserData
$User2 = [UserData]::new()
$User2.UserName = "Paul P."
$User2
