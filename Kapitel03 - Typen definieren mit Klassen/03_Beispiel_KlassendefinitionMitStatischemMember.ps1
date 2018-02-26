<#
 .Synopsis
 Definition einer Klasse mit einem statischen Member
#>

# Ein statisches Member wird direkt über die Klasse angesprochen
class UserData
{
  [String]$UserName
  Static[Int]$Index
}

# Ansprechen des statischen Members per ::-Operator

[UserData]::Index = 1
