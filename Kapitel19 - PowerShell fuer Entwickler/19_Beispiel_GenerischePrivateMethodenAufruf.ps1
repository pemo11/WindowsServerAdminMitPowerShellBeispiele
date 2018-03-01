<#
  .Synopsis 
  Aufruf einer Methode mit generischen Parameter
#> 

$CSCode = @'
using System; using System.Collections.Generic;

public class GTest
{
  private static void GetData<T>(T Arg)
  {
    Console.WriteLine("Der Wert ist: {0}, der Typ ist: {1}", Arg, Arg.GetType().FullName);
  }
} 
'@  

Add-Type -TypeDefinition $CSCode -Language CSharp 

# Der direkte Aufruf geht nicht
# [GTest]::GetData("Aber Hallo") 
# Aufruf muss per Reflection durchgeführt werden 
$f1 = [System.Reflection.BindingFlags]::NonPublic
$f2 = [System.Reflection.BindingFlags]::Static
[GTest].GetMethod("GetData", $f1 -bor $f2)

# Nette Abkürzung
$m = [GTest].GetMethod("GetData", @("Static","NonPublic"))
$mg = $M.MakeGenericMethod([String]) 

# Jetzt fehlt nur noch der Aufruf der Methode
$mg.Invoke($null, "1234") 
# Der folgende Aufruf geht dann nicht mehr, da ein String erwartet wird
$mg.Invoke($null, 1234)

 