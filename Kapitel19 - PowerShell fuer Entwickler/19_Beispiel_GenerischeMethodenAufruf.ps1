<#
 .Synopsis
  Aufruf einer Methode mit generischen Parameter
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

Add-Type -TypeDefinition $CSCode -Language CSharp 

[GTest]::GetData("Aber Hallo")
[GTest]::GetData(1234)