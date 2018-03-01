<#
  .Synopsis 
  Aufruf einer Methode mit generischen Parameter
  .Description
  Dieses Mal ist es persönlich, pardon, die Methode ist privat
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

# Hinzufügen des Typs GTest mit der generischen Methode GetData

Add-Type -TypeDefinition $CSCode -Language CSharp 

# Der direkte Aufruf geht nicht, da die Methode private ist
# [GTest]::GetData("Aber Hallo") 

# Der Aufruf muss daher offiziell per Reflection durchgeführt werden 
$f1 = [System.Reflection.BindingFlags]::NonPublic
$f2 = [System.Reflection.BindingFlags]::Static
[GTest].GetMethod("GetData", $f1 -bor $f2)

# Nette Abkürzung, die zeigt, dass es auch ohne Reflection geht
$m = [GTest].GetMethod("GetData", @("Static","NonPublic"))
$mg = $M.MakeGenericMethod([String]) 

# Jetzt fehlt nur noch der Aufruf der Methode
$mg.Invoke($null, "1234") 
# Der folgende Aufruf geht dann nicht mehr, da ein String erwartet wird
$mg.Invoke($null, 1234) 