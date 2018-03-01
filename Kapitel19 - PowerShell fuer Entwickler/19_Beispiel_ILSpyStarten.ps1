<#
.Synopsis
 Zeigt eine Assembly im ILSpy an
 .Description
 IL Spy ist ein Open Source-Tool, das den Inhalt einer Assemblydatei, d.h. ihre Typen
 und deren Members anzeigt und die Befehle eines Methodenmembers auch
 .Notes
 Setzt voraus, dass ILSpy bereits installiert wurde
#>
function Show-ILSpy
{
    [CmdletBinding(DefaultParameterSetname="")]
    param([Parameter(Mandatory=$true, ParametersetName="Path")][String]$Path,
          [Parameter(Mandatory=$true, ParametersetName="Type")][Type]$Type
         )
    # Feststellen, ob ILSpy installiert ist
    if (Test-Path -Path "$env:ProgramFiles\ILSpy\ILSpy.exe")
    {
        $IlspyPath = "$env:ProgramFiles\ILSpy\ILSpy.exe"
    }
    if (Test-Path -Path "$env:ProgramFiles(x86)\ILSpy\ILSpy.exe")
    {
        $IlspyPath = "$env:ProgramFiles(x86)\ILSpy\ILSpy.exe"
    }
    if ($IlspyPath -eq $null)
    {
        throw "Ilspy.exe nicht gefunden - unter http://ilspy.net installieren"
    }
    
    if ($PSBoundParameters["Type"])
    {
        $Path = $Type.Assembly.Location
    }

    Start-Process -FilePath $IlspyPath -ArgumentList $Path
} 
