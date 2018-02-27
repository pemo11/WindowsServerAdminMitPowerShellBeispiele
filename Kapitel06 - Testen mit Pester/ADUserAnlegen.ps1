<#
 .Synopsis
 Diese Function soll getestet werden
 .Notes
 Die Cmdlets Get-ADGroup, New-ADGroup und Add-ADGroupMember gibt es auf dem Computer
 nicht, auf dem der Test ausgeführt wird
#>
function Create-UserAccount
{
    param([String]$Accountname, [String]$Groupname="PsKurs")

    New-ADUser -Name $Accountname
    if ((Get-ADGroup -Identity $Groupname -ErrorAction Ignore).Name -ne $Groupname)
    {
      New-ADGroup -Name $Groupname -GroupCategory Security -GroupScope DomainLocal
    }
    Add-ADGroupMember -Identity $Groupname -Members $Accountname
}