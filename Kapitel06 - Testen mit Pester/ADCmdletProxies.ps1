<#
 .Synopsis
 Verschiedene AD-Cmdlets werden als Functions "nachgebaut"
#>

function New-ADUser
{
    [CmdletBinding()]
    param([String]$Name)
}

function Add-ADGroupMember
{
    [CmdletBinding()]
    param([String]$Identity, [String[]]$Members)

}

function Get-AdGroup
{
    [CmdletBinding()]
    param([String]$Identity)

}

function New-ADGroup
{
    [CmdletBinding()]
    param([String]$Name, [Object]$GroupCategory, [Object]$GroupScope)

}
