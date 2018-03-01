<#
 .Synopsis
  Aufruf einer Methode mit generischen Parameter
  .Description
  Einige Methoden der.NET-Laufzeit sind generisch, das heißt der Datentyp des Parameters
  wird erst zur Laufzeit festgelegt
  .Notes
  Der Aufruf einer generischen Methode unterscheidet sich nicht vom Aufruf einer
  nicht generischen Methode, wenn der generische Typ nicht über die Klasse angegeben wird
#> 

$CSCode = @'
using System;
using System.Collections.Generic;

public class GTest
{
    public static void GetData<T>(T Arg)
    {
        Console.WriteLine("Der Wert ist: {0}, der Typ ist: {1}", Arg, Arg.GetType().FullName);
    }
}
'@

# Typ GTest hinzufügen
Add-Type -TypeDefinition $CSCode -Language CSharp 

# Statische generische Methode GetData mehrfach mit unterschiedlichen Argumenttypen aufrufen
[GTest]::GetData("Aber Hallo")
[GTest]::GetData(1234)