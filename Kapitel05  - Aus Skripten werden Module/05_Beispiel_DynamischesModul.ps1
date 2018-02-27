<#
 .Synopsis
 Ein (seltenes) Beispiel für ein dynamisches Modul
#>

$SB = {
    function f1
    {
      "this is f1..."
    }
  
    function f2
    {
      "this is f2..."
    }
  }
  
$M = New-Module -Name IrgendEinName -ScriptBlock $SB -AsCustomObject

$M.f1()
$M.f2()

New-Module -Name IrgendEinName -ScriptBlock $SB | Import-Module 
Get-Module -Name IrgendEinName
