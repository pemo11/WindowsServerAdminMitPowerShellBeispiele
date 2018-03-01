<#
  .Synopsis
  Schließen eines Fensters über PostMessage und WM_CLOSE
  .Notes
  Wichtig: Bei FindWindow muss der erste Parameter vom Typ IntPtr sein
  und es muss [IntPtr]::Zero übergeben werden
#> 

$CSCode = @'
    using System;
    using System.Runtime.InteropServices;
    
    public static class Win32A
    {
        public static uint WM_CLOSE = 0x10;
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
        public static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);
        [DllImport("user32.dll")]
        public static extern IntPtr FindWindow(IntPtr lpClassName, string lpWindowName); 
    }
'@ 

# Hinzufügen der Klasse Win32A
# Einmal auskommentieren, da Add-Type pro PowerShell-Sitzung nur einmal ausgeführt werden kann
# Add-Type -TypeDefinition $CSCode 

# Aufruf und Schließen des Malprogramms
Start-Process Mspaint
Read-Host -Prompt "Weiter mit Taste, um MsPaint zu beenden"

$WinName = "Unbenannt - Paint" 
$Hwnd = [Win32A]::FindWindow([IntPtr]::Zero, $WinName)
[Win32A]::SendMessage($Hwnd, [Win32A]::WM_CLOSE, 0, 0)